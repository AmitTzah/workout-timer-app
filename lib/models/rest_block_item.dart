import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import '../models/workout_item.dart';

part 'rest_block_item.g.dart';

@JsonSerializable()
@HiveType(typeId: 9)
class RestBlockItem extends WorkoutItem {
  @HiveField(1) // Shifted from 0
  int durationInSeconds;

  RestBlockItem({required super.id, required this.durationInSeconds}); // Pass id to super constructor

  factory RestBlockItem.fromJson(Map<String, dynamic> json) =>
      _$RestBlockItemFromJson(json);

  Map<String, dynamic> toJson() => _$RestBlockItemToJson(this);
}
