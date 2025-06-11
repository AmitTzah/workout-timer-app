import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';
import 'package:workout_timer_app/models/workout_set.dart';
import 'package:workout_timer_app/models/workout_completion_details.dart';
import 'package:workout_timer_app/models/workout_type.dart';

part 'workout_summary.g.dart';

@JsonSerializable(explicitToJson: true)
class WorkoutSummary {
  DateTime date;

  @JsonKey(fromJson: _performedSetsFromJson, toJson: _performedSetsToJson)
  List<WorkoutSet> performedSets; // Changed from exercises to performedSets

  int totalDurationInSeconds;

  String workoutName;

  int workoutLevel;

  @JsonKey(fromJson: _boolFromInt, toJson: _boolToInt)
  bool isSurvivalMode;

  WorkoutType workoutType;

  @JsonKey(fromJson: _boolFromInt, toJson: _boolToInt)
  bool wasStoppedPrematurely;

  int totalSets;

  @JsonKey(fromJson: _completionDetailsFromJson, toJson: _completionDetailsToJson)
  WorkoutCompletionDetails? completionDetails;

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
