// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'backup_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BackupData _$BackupDataFromJson(Map<String, dynamic> json) => BackupData(
      userWorkouts: (json['userWorkouts'] as List<dynamic>)
          .map((e) => UserWorkout.fromJson(e as Map<String, dynamic>))
          .toList(),
      workoutSummaries: (json['workoutSummaries'] as List<dynamic>)
          .map((e) => WorkoutSummary.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$BackupDataToJson(BackupData instance) =>
    <String, dynamic>{
      'userWorkouts': instance.userWorkouts,
      'workoutSummaries': instance.workoutSummaries,
    };
