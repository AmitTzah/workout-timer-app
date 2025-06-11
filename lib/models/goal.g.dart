// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'goal.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Goal _$GoalFromJson(Map<String, dynamic> json) => Goal(
      description: json['description'] as String,
      targetDate: DateTime.parse(json['targetDate'] as String),
      progress: (json['progress'] as num?)?.toDouble() ?? 0.0,
    );

Map<String, dynamic> _$GoalToJson(Goal instance) => <String, dynamic>{
      'description': instance.description,
      'targetDate': instance.targetDate.toIso8601String(),
      'progress': instance.progress,
    };
