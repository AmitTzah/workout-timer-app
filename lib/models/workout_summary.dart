import 'dart:convert';
import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:workout_timer_app/models/workout_set.dart';
import 'package:workout_timer_app/models/workout_completion_details.dart';
import 'package:workout_timer_app/models/workout_type.dart';

part 'workout_summary.g.dart';

@JsonSerializable(explicitToJson: true)
@HiveType(typeId: 1)
class WorkoutSummary extends HiveObject {
  @HiveField(0)
  DateTime date;

  @HiveField(1)
  @JsonKey(fromJson: _performedSetsFromJson, toJson: _performedSetsToJson)
  List<WorkoutSet> performedSets; // Changed from exercises to performedSets

  @HiveField(2)
  int totalDurationInSeconds;

  @HiveField(3, defaultValue: '')
  String workoutName;

  @HiveField(4, defaultValue: 1) // Default level to 1
  int workoutLevel;

  @HiveField(5, defaultValue: false)
  @JsonKey(fromJson: _boolFromInt, toJson: _boolToInt)
  bool isSurvivalMode;

  @HiveField(6)
  WorkoutType workoutType;

  @HiveField(7, defaultValue: false) // New field for whether workout was stopped prematurely
  @JsonKey(fromJson: _boolFromInt, toJson: _boolToInt)
  bool wasStoppedPrematurely;

  @HiveField(8) // Re-using field 8
  int totalSets;

  @HiveField(9)
  @JsonKey(fromJson: _completionDetailsFromJson, toJson: _completionDetailsToJson)
  WorkoutCompletionDetails? completionDetails;

 @HiveField(10)
 int? id; // New field for SQFlite primary key

 WorkoutSummary({
   required this.date,
   required this.performedSets,
   required this.totalDurationInSeconds,
   required this.workoutName,
   required this.workoutLevel,
   required this.isSurvivalMode,
   required this.workoutType,
   required this.wasStoppedPrematurely,
   required this.totalSets,
   this.completionDetails,
   this.id, // Include in constructor
 });

  factory WorkoutSummary.fromJson(Map<String, dynamic> json) =>
      _$WorkoutSummaryFromJson(json);
  Map<String, dynamic> toJson() => _$WorkoutSummaryToJson(this);

  // Helper to get Duration object
  Duration get totalDuration => Duration(seconds: totalDurationInSeconds);
}

List<WorkoutSet> _performedSetsFromJson(String jsonString) =>
    (jsonDecode(jsonString) as List<dynamic>)
        .map((e) => WorkoutSet.fromJson(e as Map<String, dynamic>))
        .toList();

String _performedSetsToJson(List<WorkoutSet> object) =>
    jsonEncode(object.map((e) => e.toJson()).toList());

WorkoutCompletionDetails? _completionDetailsFromJson(String? json) =>
    json == null ? null : WorkoutCompletionDetails.fromJson(jsonDecode(json));

String? _completionDetailsToJson(WorkoutCompletionDetails? details) =>
    details == null ? null : jsonEncode(details.toJson());

bool _boolFromInt(int value) => value == 1;
int _boolToInt(bool value) => value ? 1 : 0;
