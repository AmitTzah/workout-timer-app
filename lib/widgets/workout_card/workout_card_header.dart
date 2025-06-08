import 'package:flutter/material.dart';
import 'package:exercise_timer_app/models/user_workout.dart';
import 'package:exercise_timer_app/models/workout_type.dart';
import 'package:exercise_timer_app/models/workout_item.dart';
import 'package:exercise_timer_app/models/alternating_group_item.dart';

class WorkoutCardHeader extends StatelessWidget {
  final UserWorkout workout;
  final String Function(int, {bool includeHours}) formatTime;

  const WorkoutCardHeader({
    super.key,
    required this.workout,
    required this.formatTime,
  });

  @override
  Widget build(BuildContext context) {
    final workoutType = workout.workoutType;
    final typeText = workoutType.toString().split('.').last;
    final typeColor = workoutType == WorkoutType.sequential
        ? Colors.blue
        : Colors.deepPurpleAccent.shade100;

    int totalSetsOrCycles = 0;
    if (workoutType == WorkoutType.sequential) {
      totalSetsOrCycles = workout.items
          .whereType<ExerciseItem>()
          .fold(0, (sum, item) => sum + item.exercise.sets);
    } else if (workoutType == WorkoutType.alternating) {
      totalSetsOrCycles = workout.items
          .whereType<AlternatingGroupItem>()
          .fold(0, (sum, item) => sum + item.cycles);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              workout.name,
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            Chip(
              label: Text(
                typeText,
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
              ),
              backgroundColor: typeColor,
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
            'Total Time: ${formatTime(workout.totalWorkoutTime, includeHours: true)}'),
        const SizedBox(height: 4),
        Text('Total ${workoutType == WorkoutType.sequential ? "Sets" : "Cycles"}: $totalSetsOrCycles'),
      ],
    );
  }
}
