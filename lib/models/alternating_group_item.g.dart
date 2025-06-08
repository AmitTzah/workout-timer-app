// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'alternating_group_item.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AlternatingGroupItemAdapter extends TypeAdapter<AlternatingGroupItem> {
  @override
  final int typeId = 8;

  @override
  AlternatingGroupItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AlternatingGroupItem(
      id: fields[0] as String,
      name: fields[1] as String,
      cycles: fields[2] as int,
      groupRestInSeconds: fields[3] as int?,
      exercises: (fields[4] as List).cast<Exercise>(),
    );
  }

  @override
  void write(BinaryWriter writer, AlternatingGroupItem obj) {
    writer
      ..writeByte(5)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.cycles)
      ..writeByte(3)
      ..write(obj.groupRestInSeconds)
      ..writeByte(4)
      ..write(obj.exercises)
      ..writeByte(0)
      ..write(obj.id);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AlternatingGroupItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
