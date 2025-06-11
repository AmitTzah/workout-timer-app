import 'package:json_annotation/json_annotation.dart';
import '../models/exercise.dart';
import '../models/workout_item.dart';

part 'alternating_group_item.g.dart';

@JsonSerializable(explicitToJson: true)
class AlternatingGroupItem extends WorkoutItem {
  String name; // Name of the alternating group
  
  int cycles; // Number of cycles for this group

  int? groupRestInSeconds; // Rest time between cycles for this group

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
