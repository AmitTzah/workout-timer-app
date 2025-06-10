import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:workout_timer_app/models/workout_item.dart';

part 'rest_block_item.g.dart';

@JsonSerializable()
@HiveType(typeId: 9)
class RestBlockItem extends WorkoutItem {
  @HiveField(1) // Shifted from 0
  int durationInSeconds;

  RestBlockItem({required super.id, required this.durationInSeconds}); // Pass id to super constructor

  factory RestBlockItem.fromJson(Map<String, dynamic> json) =>
      _$RestBlockItemFromJson(json);

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': 'RestBlockItem', // Indicate the concrete type
      'id': id,
      'durationInSeconds': durationInSeconds,
    };
  }
}
