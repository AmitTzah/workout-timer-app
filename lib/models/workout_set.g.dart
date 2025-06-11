// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workout_set.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WorkoutSetAdapter extends TypeAdapter<WorkoutSet> {
  @override
  final int typeId = 6;

  @override
  WorkoutSet read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WorkoutSet(
      exercise: fields[1] as Exercise,
      setNumber: fields[2] as int,
      isRestSet: fields[3] as bool,
      isRestBlock: fields[4] as bool,
      restBlockDuration: fields[5] as int?,
      id: fields[0] as String,
    );
  }

  @override
  void write(BinaryWriter writer, WorkoutSet obj) {
    writer
      ..writeByte(6)
      ..writeByte(1)
      ..write(obj.exercise)
      ..writeByte(2)
      ..write(obj.setNumber)
      ..writeByte(3)
      ..write(obj.isRestSet)
      ..writeByte(4)
      ..write(obj.isRestBlock)
      ..writeByte(5)
      ..write(obj.restBlockDuration)
      ..writeByte(0)
      ..write(obj.id);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WorkoutSetAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

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
