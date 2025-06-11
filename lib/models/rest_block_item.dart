import 'package:json_annotation/json_annotation.dart';
import '../models/workout_item.dart';

part 'rest_block_item.g.dart';

@JsonSerializable()
class RestBlockItem extends WorkoutItem {
  int durationInSeconds;

  RestBlockItem({required super.id, required this.durationInSeconds}); // Pass id to super constructor

  factory RestBlockItem.fromJson(Map<String, dynamic> json) =>
      _$RestBlockItemFromJson(json);

  Map<String, dynamic> toJson() => _$RestBlockItemToJson(this);
}
