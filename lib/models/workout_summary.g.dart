// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workout_summary.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WorkoutSummary _$WorkoutSummaryFromJson(Map<String, dynamic> json) =>
    WorkoutSummary(
      date: DateTime.parse(json['date'] as String),
      performedSets: _performedSetsFromJson(json['performedSets'] as String),
      totalDurationInSeconds: (json['totalDurationInSeconds'] as num).toInt(),
      workoutName: json['workoutName'] as String,
      workoutLevel: (json['workoutLevel'] as num).toInt(),
      isSurvivalMode: _boolFromInt((json['isSurvivalMode'] as num).toInt()),
      workoutType: $enumDecode(_$WorkoutTypeEnumMap, json['workoutType']),
      wasStoppedPrematurely:
          _boolFromInt((json['wasStoppedPrematurely'] as num).toInt()),
      totalSets: (json['totalSets'] as num).toInt(),
      completionDetails:
          _completionDetailsFromJson(json['completionDetails'] as String?),
      notes: json['notes'] as String?,
      id: (json['id'] as num?)?.toInt(),
    );

Map<String, dynamic> _$WorkoutSummaryToJson(WorkoutSummary instance) =>
    <String, dynamic>{
      'date': instance.date.toIso8601String(),
      'performedSets': _performedSetsToJson(instance.performedSets),
      'totalDurationInSeconds': instance.totalDurationInSeconds,
      'workoutName': instance.workoutName,
      'workoutLevel': instance.workoutLevel,
      'isSurvivalMode': _boolToInt(instance.isSurvivalMode),
      'workoutType': _$WorkoutTypeEnumMap[instance.workoutType]!,
      'wasStoppedPrematurely': _boolToInt(instance.wasStoppedPrematurely),
      'totalSets': instance.totalSets,
      'completionDetails': _completionDetailsToJson(instance.completionDetails),
      'notes': instance.notes,
      'id': instance.id,
    };

const _$WorkoutTypeEnumMap = {
  WorkoutType.sequential: 'sequential',
  WorkoutType.alternating: 'alternating',
};
