import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:workout_timer_app/models/exercise.dart';
import '../models/workout_item.dart';

part 'workout_set.g.dart';

@JsonSerializable(explicitToJson: true)
@HiveType(typeId: 6) // Changed typeId to 6
class WorkoutSet extends WorkoutItem {
  @HiveField(1)
  Exercise exercise; // Keep for now, will be refactored to WorkoutItem later

  @HiveField(2)
  int setNumber;

  @HiveField(3)
  bool isRestSet;

  @HiveField(4) // New field to indicate if this is a dedicated rest block
  bool isRestBlock;

  @HiveField(5) // New field for rest block duration
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
