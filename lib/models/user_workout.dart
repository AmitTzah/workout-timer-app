import 'package:hive/hive.dart';
import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';
import '../models/workout_item.dart';
import '../models/workout_type.dart';
import '../utils/workout_item_converter.dart';

part 'user_workout.g.dart';

@JsonSerializable(explicitToJson: true)
@HiveType(typeId: 2) // Use a new unique typeId
class UserWorkout extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  @JsonKey(toJson: _workoutItemListToJson, fromJson: _workoutItemListFromJson)
  List<WorkoutItem> items;

  @HiveField(3)
  int totalWorkoutTime; // in seconds

  @HiveField(4)
  WorkoutType workoutType;

  @HiveField(5)
  int? selectedLevel; // Nullable, default to 1 if null

  @HiveField(6) // Re-using field 6
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
