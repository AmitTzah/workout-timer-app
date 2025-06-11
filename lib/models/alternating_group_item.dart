import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import '../models/exercise.dart';
import '../models/workout_item.dart';

part 'alternating_group_item.g.dart';

@JsonSerializable(explicitToJson: true)
@HiveType(typeId: 8)
class AlternatingGroupItem extends WorkoutItem {
  @HiveField(1) // Shifted from 0
  String name; // Name of the alternating group
  
  @HiveField(2) // Shifted from 1
  int cycles; // Number of cycles for this group

  @HiveField(3) // Shifted from 2
  int? groupRestInSeconds; // Rest time between cycles for this group

  @HiveField(4) // Shifted from 3
  List<Exercise> exercises;

  AlternatingGroupItem({
    required super.id, // Pass id to super constructor
    required this.name,
    required this.cycles,
    this.groupRestInSeconds,
    required this.exercises,
  });

  factory AlternatingGroupItem.fromJson(Map<String, dynamic> json) =>
      _$AlternatingGroupItemFromJson(json);

  Map<String, dynamic> toJson() => _$AlternatingGroupItemToJson(this);
}
