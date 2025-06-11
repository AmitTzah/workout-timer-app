// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rest_block_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RestBlockItem _$RestBlockItemFromJson(Map<String, dynamic> json) =>
    RestBlockItem(
      id: json['id'] as String,
      durationInSeconds: (json['durationInSeconds'] as num).toInt(),
    );

Map<String, dynamic> _$RestBlockItemToJson(RestBlockItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'durationInSeconds': instance.durationInSeconds,
    };
