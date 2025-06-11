import 'package:workout_timer_app/models/workout_summary.dart';

abstract class WorkoutSummaryRepository {
  Future<void> saveWorkoutSummary(WorkoutSummary summary);
  Future<List<WorkoutSummary>> getAllWorkoutSummaries();
  Future<void> deleteWorkoutSummary(int key);
  Future<void> clearAllWorkoutSummaries();
  Stream<List<WorkoutSummary>> get workoutSummariesStream;
  Stream<List<WorkoutSummary>> watchAllWorkoutSummaries();
}
