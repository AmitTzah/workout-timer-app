// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rest_block_item.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RestBlockItemAdapter extends TypeAdapter<RestBlockItem> {
  @override
  final int typeId = 9;

  @override
  RestBlockItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RestBlockItem(
      id: fields[0] as String,
      durationInSeconds: fields[1] as int,
    );
  }

  @override
  void write(BinaryWriter writer, RestBlockItem obj) {
    writer
      ..writeByte(2)
      ..writeByte(1)
      ..write(obj.durationInSeconds)
      ..writeByte(0)
      ..write(obj.id);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RestBlockItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
