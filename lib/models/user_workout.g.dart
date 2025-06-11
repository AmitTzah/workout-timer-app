// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_workout.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserWorkout _$UserWorkoutFromJson(Map<String, dynamic> json) => UserWorkout(
      id: json['id'] as String,
      name: json['name'] as String,
      items: UserWorkout._workoutItemListFromJson(json['items'] as String),
      totalWorkoutTime: (json['totalWorkoutTime'] as num).toInt(),
      workoutType:
          $enumDecodeNullable(_$WorkoutTypeEnumMap, json['workoutType']) ??
              WorkoutType.sequential,
      selectedLevel: (json['selectedLevel'] as num?)?.toInt(),
      selectedSurvivalMode: const BooleanConverter()
          .fromJson((json['selectedSurvivalMode'] as num?)?.toInt()),
    );

Map<String, dynamic> _$UserWorkoutToJson(UserWorkout instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'items': UserWorkout._workoutItemListToJson(instance.items),
      'totalWorkoutTime': instance.totalWorkoutTime,
      'workoutType': _$WorkoutTypeEnumMap[instance.workoutType]!,
      'selectedLevel': instance.selectedLevel,
      'selectedSurvivalMode':
          const BooleanConverter().toJson(instance.selectedSurvivalMode),
    };

const _$WorkoutTypeEnumMap = {
  WorkoutType.sequential: 'sequential',
  WorkoutType.alternating: 'alternating',
};
