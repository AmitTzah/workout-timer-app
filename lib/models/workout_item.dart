import 'package:hive/hive.dart';
import 'package:exercise_timer_app/models/exercise.dart';

part 'workout_item.g.dart';

abstract class WorkoutItem extends HiveObject {
  @HiveField(0) // Assign a HiveField index to the ID
  String id;

  WorkoutItem({required this.id});
}

@HiveType(typeId: 3) // Changed typeId for ExerciseItem
class ExerciseItem extends WorkoutItem {
  @HiveField(1) // Changed to 1 to avoid conflict with WorkoutItem's id
  Exercise exercise;

  ExerciseItem({required this.exercise, required super.id}); // Pass id to super constructor
}
