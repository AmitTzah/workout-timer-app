// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workout_item.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ExerciseItemAdapter extends TypeAdapter<ExerciseItem> {
  @override
  final int typeId = 3;

  @override
  ExerciseItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ExerciseItem(
      exercise: fields[1] as Exercise,
      id: fields[0] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ExerciseItem obj) {
    writer
      ..writeByte(2)
      ..writeByte(1)
      ..write(obj.exercise)
      ..writeByte(0)
      ..write(obj.id);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExerciseItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExerciseItem _$ExerciseItemFromJson(Map<String, dynamic> json) => ExerciseItem(
      exercise: Exercise.fromJson(json['exercise'] as Map<String, dynamic>),
      id: json['id'] as String,
    );

Map<String, dynamic> _$ExerciseItemToJson(ExerciseItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'exercise': instance.exercise.toJson(),
    };
