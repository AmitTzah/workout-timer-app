import 'package:json_annotation/json_annotation.dart';
import 'package:workout_timer_app/models/alternating_group_item.dart';
import 'package:workout_timer_app/models/rest_block_item.dart';
import 'package:workout_timer_app/models/workout_item.dart';

class WorkoutItemConverter implements JsonConverter<WorkoutItem, Map<String, dynamic>> {
  const WorkoutItemConverter();

  @override
  WorkoutItem fromJson(Map<String, dynamic> json) {
    final type = json['type'] as String;
    switch (type) {
      case 'ExerciseItem':
        return ExerciseItem.fromJson(json);
      case 'AlternatingGroupItem':
        return AlternatingGroupItem.fromJson(json);
      case 'RestBlockItem':
        return RestBlockItem.fromJson(json);
      default:
        throw ArgumentError('Unknown WorkoutItem type: $type');
    }
  }

  @override
  Map<String, dynamic> toJson(WorkoutItem object) {
    // This will call the toJson method on the concrete type
    return object.toJson();
  }
}
