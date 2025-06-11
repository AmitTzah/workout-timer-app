// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workout_set.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WorkoutSet _$WorkoutSetFromJson(Map<String, dynamic> json) => WorkoutSet(
      exercise: Exercise.fromJson(json['exercise'] as Map<String, dynamic>),
      setNumber: (json['setNumber'] as num).toInt(),
      isRestSet: json['isRestSet'] as bool? ?? false,
      isRestBlock: json['isRestBlock'] as bool? ?? false,
      restBlockDuration: (json['restBlockDuration'] as num?)?.toInt(),
      id: json['id'] as String,
    );

Map<String, dynamic> _$WorkoutSetToJson(WorkoutSet instance) =>
    <String, dynamic>{
      'id': instance.id,
      'exercise': instance.exercise.toJson(),
      'setNumber': instance.setNumber,
      'isRestSet': instance.isRestSet,
      'isRestBlock': instance.isRestBlock,
      'restBlockDuration': instance.restBlockDuration,
    };
