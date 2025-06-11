import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';
import '../models/workout_item.dart';
import '../models/workout_type.dart';
import '../utils/workout_item_converter.dart';
import '../utils/boolean_converter.dart'; // Import the new converter

part 'user_workout.g.dart';

@JsonSerializable(explicitToJson: true)
class UserWorkout {
  String id;

  String name;

  @JsonKey(toJson: _workoutItemListToJson, fromJson: _workoutItemListFromJson)
  List<WorkoutItem> items;

  int totalWorkoutTime; // in seconds

  WorkoutType workoutType;

  int? selectedLevel; // Nullable, default to 1 if null

  @BooleanConverter()
  bool? selectedSurvivalMode; // Nullable, default to false if null

  UserWorkout({
    required this.id,
    required this.name,
    required this.items,
    required this.totalWorkoutTime,
    this.workoutType = WorkoutType.sequential, // Default to sequential
    this.selectedLevel,
    this.selectedSurvivalMode,
  });

  factory UserWorkout.fromJson(Map<String, dynamic> json) =>
      _$UserWorkoutFromJson(json);
  Map<String, dynamic> toJson() => _$UserWorkoutToJson(this);

  static String _workoutItemListToJson(List<WorkoutItem> items) {
    final converter = WorkoutItemConverter();
    final List<Map<String, dynamic>> jsonList =
        items.map((item) => converter.toJson(item) as Map<String, dynamic>).toList();
    return jsonEncode(jsonList);
  }

  static List<WorkoutItem> _workoutItemListFromJson(String jsonString) {
    final converter = WorkoutItemConverter();
    final List<dynamic> decodedList = jsonDecode(jsonString) as List<dynamic>;
    return decodedList
        .map((itemJson) => converter.fromJson(itemJson as Object))
        .toList();
  }
}
