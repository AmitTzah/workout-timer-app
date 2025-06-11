import '../models/user_workout.dart';

abstract class UserWorkoutRepository {
  Future<List<UserWorkout>> getAllWorkouts();
  Future<UserWorkout?> getWorkoutById(String id);
  Future<void> saveWorkout(UserWorkout workout);
  Future<void> deleteWorkout(String id);
  Stream<List<UserWorkout>> watchAllWorkouts();
  Future<void> clearAllWorkouts();
}
