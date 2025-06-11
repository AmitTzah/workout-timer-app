import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart'; // For debugPrint
import 'package:workout_timer_app/models/backup_data.dart';
import 'package:workout_timer_app/repositories/user_workout_repository.dart';
import 'package:workout_timer_app/repositories/workout_summary_repository.dart';

class BackupService {
  final UserWorkoutRepository _userWorkoutRepository;
  final WorkoutSummaryRepository _workoutSummaryRepository;

  BackupService(this._userWorkoutRepository, this._workoutSummaryRepository);

  Future<String> exportData() async {
    try {
      final userWorkouts = await _userWorkoutRepository.getAllWorkouts();
      final workoutSummaries = await _workoutSummaryRepository.getAllWorkoutSummaries();

      final backupData = BackupData(
        userWorkouts: userWorkouts,
        workoutSummaries: workoutSummaries,
      );

      final jsonString = jsonEncode(backupData.toJson());
      final Uint8List fileBytes = utf8.encode(jsonString); // Convert String to Uint8List

      String? outputFile = await FilePicker.platform.saveFile(
        dialogTitle: 'Save Workout Data Backup',
        fileName: 'workout_backup.json',
        type: FileType.custom,
        allowedExtensions: ['json'],
        bytes: fileBytes, // Provide the bytes directly
      );

      if (outputFile != null) {
        // The file is already saved by file_picker when bytes are provided
        debugPrint('Data exported successfully to: $outputFile');
        return 'Data exported successfully!';
      } else {
        debugPrint('File save cancelled by user.');
        return 'Export cancelled.';
      }
    } catch (e) {
      debugPrint('Error exporting data: $e');
      return 'Error exporting data: $e';
    }
  }

  Future<String> importData() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.any, // Use FileType.any for broader compatibility
        // allowedExtensions: ['json'], // Removed as it conflicts with FileType.any on some platforms/versions
        allowMultiple: false,
      );

      if (result != null && result.files.single.path != null) {
        final filePath = result.files.single.path!;
        // Manual check for .json extension
        if (!filePath.toLowerCase().endsWith('.json')) {
          debugPrint('Invalid file type selected. Please select a .json file.');
          return 'Invalid file type. Please select a .json backup file.';
        }

        final file = File(filePath);
        final jsonString = await file.readAsString();

        final Map<String, dynamic> jsonMap = jsonDecode(jsonString);
        final backupData = BackupData.fromJson(jsonMap);

        // Clear existing data
        await _userWorkoutRepository.clearAllWorkouts();
        await _workoutSummaryRepository.clearAllWorkoutSummaries();

        // Import new data
        for (var workout in backupData.userWorkouts) {
          await _userWorkoutRepository.saveWorkout(workout);
        }
        for (var summary in backupData.workoutSummaries) {
          await _workoutSummaryRepository.saveWorkoutSummary(summary);
        }

        debugPrint('Data imported successfully.');
        return 'Data imported successfully!';
      } else {
        debugPrint('File pick cancelled by user.');
        return 'Import cancelled.';
      }
    } catch (e) {
      debugPrint('Error importing data: $e');
      return 'Error importing data: $e';
    }
  }
}
