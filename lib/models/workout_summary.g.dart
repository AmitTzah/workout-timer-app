// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workout_summary.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WorkoutSummaryAdapter extends TypeAdapter<WorkoutSummary> {
  @override
  final int typeId = 1;

  @override
  WorkoutSummary read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WorkoutSummary(
      date: fields[0] as DateTime,
      performedSets: (fields[1] as List).cast<WorkoutSet>(),
      totalDurationInSeconds: fields[2] as int,
      workoutName: fields[3] == null ? '' : fields[3] as String,
      workoutLevel: fields[4] == null ? 1 : fields[4] as int,
      isSurvivalMode: fields[5] == null ? false : fields[5] as bool,
      workoutType: fields[6] as WorkoutType,
      wasStoppedPrematurely: fields[7] == null ? false : fields[7] as bool,
      totalSets: fields[8] as int,
      completionDetails: fields[9] as WorkoutCompletionDetails?,
      id: fields[10] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, WorkoutSummary obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.date)
      ..writeByte(1)
      ..write(obj.performedSets)
      ..writeByte(2)
      ..write(obj.totalDurationInSeconds)
      ..writeByte(3)
      ..write(obj.workoutName)
      ..writeByte(4)
      ..write(obj.workoutLevel)
      ..writeByte(5)
      ..write(obj.isSurvivalMode)
      ..writeByte(6)
      ..write(obj.workoutType)
      ..writeByte(7)
      ..write(obj.wasStoppedPrematurely)
      ..writeByte(8)
      ..write(obj.totalSets)
      ..writeByte(9)
      ..write(obj.completionDetails)
      ..writeByte(10)
      ..write(obj.id);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WorkoutSummaryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

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
      'id': instance.id,
    };

const _$WorkoutTypeEnumMap = {
  WorkoutType.sequential: 'sequential',
  WorkoutType.alternating: 'alternating',
};
