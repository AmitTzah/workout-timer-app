// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'alternating_group_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AlternatingGroupItem _$AlternatingGroupItemFromJson(
        Map<String, dynamic> json) =>
    AlternatingGroupItem(
      id: json['id'] as String,
      name: json['name'] as String,
      cycles: (json['cycles'] as num).toInt(),
      groupRestInSeconds: (json['groupRestInSeconds'] as num?)?.toInt(),
      exercises: (json['exercises'] as List<dynamic>)
          .map((e) => Exercise.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$AlternatingGroupItemToJson(
        AlternatingGroupItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'cycles': instance.cycles,
      'groupRestInSeconds': instance.groupRestInSeconds,
      'exercises': instance.exercises.map((e) => e.toJson()).toList(),
    };
