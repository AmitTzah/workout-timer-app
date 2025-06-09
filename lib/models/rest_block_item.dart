import 'package:hive/hive.dart';
import 'package:workout_timer_app/models/workout_item.dart';

part 'rest_block_item.g.dart';

@HiveType(typeId: 9)
class RestBlockItem extends WorkoutItem {
  @HiveField(1) // Shifted from 0
  int durationInSeconds;

  RestBlockItem({required super.id, required this.durationInSeconds}); // Pass id to super constructor
}
