import 'package:hive_flutter/hive_flutter.dart'; // For Box
import 'package:flutter/foundation.dart'; // For ValueListenable
import 'package:workout_timer_app/models/workout_summary.dart';

class WorkoutSummaryRepository {
  final Box<WorkoutSummary> _workoutSummariesBox;

  WorkoutSummaryRepository(this._workoutSummariesBox);

  Future<void> saveWorkoutSummary(WorkoutSummary summary) async {
    // Hive uses auto-incrementing keys for add(), but for import, we might want to
    // ensure uniqueness or replace existing. For simplicity, we'll just add.
    // If summaries have unique IDs, we could use put(summary.id, summary)
    // For now, add() is fine for new imports.
    await _workoutSummariesBox.add(summary);
  }

  List<WorkoutSummary> getAllWorkoutSummaries() {
    return _workoutSummariesBox.values.toList();
  }

  Future<void> deleteWorkoutSummary(int key) async {
    await _workoutSummariesBox.delete(key);
  }

  Future<void> clearAllWorkoutSummaries() async {
    await _workoutSummariesBox.clear();
  }

  ValueListenable<Box<WorkoutSummary>> get listenable => _workoutSummariesBox.listenable();
}
