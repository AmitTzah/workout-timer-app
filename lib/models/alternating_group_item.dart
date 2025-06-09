import 'package:hive/hive.dart';
import 'package:workout_timer_app/models/exercise.dart';
import 'package:workout_timer_app/models/workout_item.dart';

part 'alternating_group_item.g.dart';

@HiveType(typeId: 8)
class AlternatingGroupItem extends WorkoutItem {
  @HiveField(1) // Shifted from 0
  String name; // Name of the alternating group
  
  @HiveField(2) // Shifted from 1
  int cycles; // Number of cycles for this group

  @HiveField(3) // Shifted from 2
  int? groupRestInSeconds; // Rest time between cycles for this group

  @HiveField(4) // Shifted from 3
  List<Exercise> exercises;

  AlternatingGroupItem({
    required super.id, // Pass id to super constructor
    required this.name,
    required this.cycles,
    this.groupRestInSeconds,
    required this.exercises,
  });
}
