import 'package:hive/hive.dart';
import 'package:workout_timer_app/models/exercise.dart';
import 'package:workout_timer_app/models/alternating_group_item.dart';
import 'package:workout_timer_app/models/rest_block_item.dart';

part 'workout_item.g.dart';

@HiveType(typeId: 4)
abstract class WorkoutItem extends HiveObject {
  @HiveField(0) // Assign a HiveField index to the ID
  String id;

  WorkoutItem({required this.id});

  Map<String, dynamic> toMap(); // Abstract method
}

@HiveType(typeId: 3) // Changed typeId for ExerciseItem
class ExerciseItem extends WorkoutItem {
  @HiveField(1) // Changed to 1 to avoid conflict with WorkoutItem's id
  Exercise exercise;

  ExerciseItem({required this.exercise, required super.id}); // Pass id to super constructor

  @override
  Map<String, dynamic> toMap() {
    return {
      'type': 'ExerciseItem', // Indicate the concrete type
      'id': id,
      'exercise': exercise.toMap(), // Assuming Exercise also has a toMap()
    };
  }
}
