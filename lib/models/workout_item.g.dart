// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workout_item.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WorkoutItemAdapter extends TypeAdapter<WorkoutItem> {
  @override
  final int typeId = 4;

  @override
  WorkoutItem read(BinaryReader reader) {
    final typeId = reader.readByte();
    switch (typeId) {
      case 3:
        return reader.read() as ExerciseItem;
      case 8:
        return reader.read() as AlternatingGroupItem;
      case 9:
        return reader.read() as RestBlockItem;
      default:
        throw HiveError('Cannot read WorkoutItem. Unknown typeId: $typeId');
    }
  }

  @override
  void write(BinaryWriter writer, WorkoutItem obj) {
    if (obj is ExerciseItem) {
      writer.writeByte(3);
      writer.write(obj);
    } else if (obj is AlternatingGroupItem) {
      writer.writeByte(8);
      writer.write(obj);
    } else if (obj is RestBlockItem) {
      writer.writeByte(9);
      writer.write(obj);
    } else {
      throw HiveError('Cannot write WorkoutItem. Unknown type: \${obj.runtimeType}');
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WorkoutItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

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
      id: fields[0] as String,
      exercise: fields[1] as Exercise,
    );
  }

  @override
  void write(BinaryWriter writer, ExerciseItem obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.exercise);
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
