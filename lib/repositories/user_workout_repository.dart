import 'package:hive_flutter/hive_flutter.dart'; // For ValueListenable and Box
import 'package:workout_timer_app/models/user_workout.dart';
import 'package:flutter/foundation.dart'; // For ValueListenable
import 'dart:developer' as developer;
import 'dart:convert'; // For jsonEncode

class UserWorkoutRepository {
  final Box<UserWorkout> _userWorkoutsBox;

  UserWorkoutRepository(this._userWorkoutsBox);

  Future<void> saveUserWorkout(UserWorkout workout) async {
    developer.log('[UserWorkoutRepository] Attempting to save workout with ID: ${workout.id}, Name: ${workout.name}', name: 'UserWorkoutRepository');
    
    // Log the full workout object for debugging
    try {
      final workoutJson = JsonEncoder.withIndent('  ').convert(workout.toMap());
      developer.log('[UserWorkoutRepository] Workout data being saved: $workoutJson', name: 'UserWorkoutRepository');
    } catch (e) {
      developer.log('[UserWorkoutRepository] Error converting workout to map for logging: $e', name: 'UserWorkoutRepository');
    }

    try {
      await _userWorkoutsBox.put(workout.id, workout);
      developer.log('[UserWorkoutRepository] Successfully saved workout with ID: ${workout.id}', name: 'UserWorkoutRepository');
    } catch (e, stack) {
      developer.log('[UserWorkoutRepository] Error saving workout with ID: ${workout.id}: $e\n$stack', name: 'UserWorkoutRepository', error: e, stackTrace: stack);
      rethrow; // Re-throw the error so it can be caught by the UI layer
    }
  }

  UserWorkout? getUserWorkout(String id) {
    return _userWorkoutsBox.get(id);
  }

  List<UserWorkout> getAllUserWorkouts() {
    return _userWorkoutsBox.values.toList();
  }

  Future<void> deleteUserWorkout(String id) async {
    await _userWorkoutsBox.delete(id);
  }

  ValueListenable<Box<UserWorkout>> get listenable => _userWorkoutsBox.listenable();
}
