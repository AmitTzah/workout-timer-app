// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exercise.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Exercise _$ExerciseFromJson(Map<String, dynamic> json) => Exercise(
      id: json['id'] as String,
      name: json['name'] as String,
      sets: (json['sets'] as num).toInt(),
      reps: (json['reps'] as num?)?.toInt(),
      audioFileName: json['audioFileName'] as String?,
      workTimeInSeconds: (json['workTimeInSeconds'] as num).toInt(),
      restTimeInSeconds: (json['restTimeInSeconds'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ExerciseToJson(Exercise instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'sets': instance.sets,
      'reps': instance.reps,
      'audioFileName': instance.audioFileName,
      'workTimeInSeconds': instance.workTimeInSeconds,
      'restTimeInSeconds': instance.restTimeInSeconds,
    };
