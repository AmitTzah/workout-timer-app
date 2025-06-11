import 'package:hive/hive.dart';
import '../user_workout_repository.dart';
import '../../models/user_workout.dart';

class HiveUserWorkoutRepositoryImpl implements UserWorkoutRepository {
  final Box<UserWorkout> _workoutBox;

  HiveUserWorkoutRepositoryImpl(this._workoutBox);

  @override
  Future<List<UserWorkout>> getAllWorkouts() async {
    return _workoutBox.values.toList();
  }

  @override
  Future<UserWorkout?> getWorkoutById(String id) async {
    return _workoutBox.get(id);
  }

  @override
  Future<void> saveWorkout(UserWorkout workout) async {
    await _workoutBox.put(workout.id, workout);
  }

  @override
  Future<void> deleteWorkout(String id) async {
    await _workoutBox.delete(id);
  }

  @override
  Stream<List<UserWorkout>> watchAllWorkouts() async* {
    // Yield the initial data immediately.
    yield _workoutBox.values.toList();
    // Yield the updated list whenever the box changes.
    await for (final _ in _workoutBox.watch()) {
      yield _workoutBox.values.toList();
    }
  }
  @override
  Future<void> clearAllWorkouts() async {
    await _workoutBox.clear();
  }
}