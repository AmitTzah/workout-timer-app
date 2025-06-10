import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:workout_timer_app/models/exercise.dart';

part 'workout_item.g.dart';

abstract class WorkoutItem extends HiveObject {
  @HiveField(0) // Assign a HiveField index to the ID
  String id;

  WorkoutItem({required this.id});

  Map<String, dynamic> toJson(); // Abstract method
}

@JsonSerializable(explicitToJson: true)
@HiveType(typeId: 3) // Changed typeId for ExerciseItem
class ExerciseItem extends WorkoutItem {
  @HiveField(1) // Changed to 1 to avoid conflict with WorkoutItem's id
  Exercise exercise;

  ExerciseItem({required this.exercise, required super.id}); // Pass id to super constructor

  factory ExerciseItem.fromJson(Map<String, dynamic> json) =>
      _$ExerciseItemFromJson(json);

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': 'ExerciseItem', // Indicate the concrete type
      'id': id,
      'exercise': exercise.toJson(), // Assuming Exercise also has a toJson()
    };
  }
}
