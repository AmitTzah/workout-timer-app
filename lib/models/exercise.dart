import 'package:json_annotation/json_annotation.dart';

import '../models/workout_item.dart';

part 'exercise.g.dart';

@JsonSerializable(explicitToJson: true)
class Exercise extends WorkoutItem {

  String name;

  int sets;

  int? reps; // Reps can be optional

  String? audioFileName; // Optional: custom audio file for this exercise

  int workTimeInSeconds;

  int? restTimeInSeconds;

  Exercise({
    required super.id,
    required this.name,
    required this.sets,
    this.reps,
    this.audioFileName,
    required this.workTimeInSeconds,
    this.restTimeInSeconds,
  });

  factory Exercise.fromJson(Map<String, dynamic> json) =>
      _$ExerciseFromJson(json);
  Map<String, dynamic> toJson() => _$ExerciseToJson(this);
}
