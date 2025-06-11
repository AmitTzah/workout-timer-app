import 'package:hive/hive.dart';
import '../workout_summary_repository.dart';
import '../../models/workout_summary.dart';

class HiveWorkoutSummaryRepositoryImpl implements WorkoutSummaryRepository {
  final Box<WorkoutSummary> _workoutSummaryBox;

  HiveWorkoutSummaryRepositoryImpl(this._workoutSummaryBox);

  @override
  Future<void> saveWorkoutSummary(WorkoutSummary summary) async {
    await _workoutSummaryBox.add(summary);
  }

  @override
  Future<List<WorkoutSummary>> getAllWorkoutSummaries() async {
    return _workoutSummaryBox.values.toList();
  }

  @override
  Future<void> deleteWorkoutSummary(int key) async {
    await _workoutSummaryBox.delete(key);
  }

  @override
  Future<void> clearAllWorkoutSummaries() async {
    await _workoutSummaryBox.clear();
  }

  @override
  Stream<List<WorkoutSummary>> get workoutSummariesStream {
    return _workoutSummaryBox.watch().map((event) => _workoutSummaryBox.values.toList());
  }
  @override
  Stream<List<WorkoutSummary>> watchAllWorkoutSummaries() async* {
    // Yield the initial data immediately.
    yield _workoutSummaryBox.values.toList();
    // Yield the updated list whenever the box changes.
    await for (final _ in _workoutSummaryBox.watch()) {
      yield _workoutSummaryBox.values.toList();
    }
  }
}