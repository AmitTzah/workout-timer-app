// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workout_completion_details.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WorkoutCompletionDetails _$WorkoutCompletionDetailsFromJson(
        Map<String, dynamic> json) =>
    WorkoutCompletionDetails(
      json['wasStoppedPrematurely'] as bool,
      (json['finalPerformedSets'] as List<dynamic>)
          .map((e) => WorkoutSet.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$WorkoutCompletionDetailsToJson(
        WorkoutCompletionDetails instance) =>
    <String, dynamic>{
      'wasStoppedPrematurely': instance.wasStoppedPrematurely,
      'finalPerformedSets':
          instance.finalPerformedSets.map((e) => e.toJson()).toList(),
    };
