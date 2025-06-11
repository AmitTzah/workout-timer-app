import 'package:hive/hive.dart';

abstract class WorkoutItem {
  @HiveField(0)
  String id;

  WorkoutItem({required this.id});
}
