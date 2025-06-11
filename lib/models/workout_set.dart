import 'package:json_annotation/json_annotation.dart';
import 'package:workout_timer_app/models/exercise.dart';
import '../models/workout_item.dart';

part 'workout_set.g.dart';

@JsonSerializable(explicitToJson: true)
class WorkoutSet extends WorkoutItem {
  Exercise exercise; // Keep for now, will be refactored to WorkoutItem later

  int setNumber;

  bool isRestSet;

  bool isRestBlock;

  int? restBlockDuration;

  WorkoutSet({
    required this.exercise,
    required this.setNumber,
    this.isRestSet = false,
    this.isRestBlock = false,
    this.restBlockDuration,
    required super.id,
  });

  factory WorkoutSet.fromJson(Map<String, dynamic> json) =>
      _$WorkoutSetFromJson(json);

  Map<String, dynamic> toJson() => _$WorkoutSetToJson(this);
}
