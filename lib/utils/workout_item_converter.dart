import 'package:json_annotation/json_annotation.dart';
import '../models/workout_item.dart';
import '../models/exercise.dart';
import '../models/workout_set.dart';
import '../models/rest_block_item.dart';
import '../models/alternating_group_item.dart';

class WorkoutItemConverter implements JsonConverter<WorkoutItem, Object> {
  const WorkoutItemConverter();

  @override
  WorkoutItem fromJson(Object json) {
    final mapJson = json as Map<String, dynamic>;
    final type = mapJson['type'] as String?;
    if (type == null) {
      throw ArgumentError('Missing "type" field in WorkoutItem JSON: $mapJson');
    }

    switch (type) {
      case 'Exercise':
        return Exercise.fromJson(mapJson);
      case 'WorkoutSet':
        return WorkoutSet.fromJson(mapJson);
      case 'RestBlockItem':
        return RestBlockItem.fromJson(mapJson);
      case 'AlternatingGroupItem':
        return AlternatingGroupItem.fromJson(mapJson);
      default:
        throw ArgumentError('Unknown WorkoutItem type: $type');
    }
  }

  @override
  Object toJson(WorkoutItem object) {
    Map<String, dynamic> json;
    if (object is Exercise) {
      json = object.toJson();
      json['type'] = 'Exercise';
    } else if (object is WorkoutSet) {
      json = object.toJson();
      json['type'] = 'WorkoutSet';
    } else if (object is RestBlockItem) {
      json = object.toJson();
      json['type'] = 'RestBlockItem';
    } else if (object is AlternatingGroupItem) {
      json = object.toJson();
      json['type'] = 'AlternatingGroupItem';
    } else {
      throw ArgumentError('Unknown WorkoutItem type for serialization: ${object.runtimeType}');
    }
    return json;
  }
}
