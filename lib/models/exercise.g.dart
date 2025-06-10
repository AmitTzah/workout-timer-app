// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exercise.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ExerciseAdapter extends TypeAdapter<Exercise> {
  @override
  final int typeId = 0;

  @override
  Exercise read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Exercise(
      id: fields[0] as String,
      name: fields[1] as String,
      sets: fields[2] as int,
      reps: fields[3] as int?,
      audioFileName: fields[4] as String?,
      workTimeInSeconds: fields[5] as int,
      restTimeInSeconds: fields[6] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, Exercise obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.sets)
      ..writeByte(3)
      ..write(obj.reps)
      ..writeByte(4)
      ..write(obj.audioFileName)
      ..writeByte(5)
      ..write(obj.workTimeInSeconds)
      ..writeByte(6)
      ..write(obj.restTimeInSeconds);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExerciseAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

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
