import 'package:flutter/material.dart';
import 'package:exercise_timer_app/models/user_workout.dart';
import 'package:exercise_timer_app/widgets/workout_card/workout_card_header.dart';
import 'package:exercise_timer_app/widgets/workout_card/workout_plan.dart';
import 'package:exercise_timer_app/widgets/workout_card/workout_card_controls.dart';

class WorkoutCard extends StatelessWidget {
  final UserWorkout workout;
  final String Function(int, {bool includeHours}) formatTime;
  final Function(BuildContext, dynamic, UserWorkout)
      showLevelSelectionBottomSheet;
  final Function(String) deleteWorkout;
  final Map<String, int> levelSelections;
  final Map<String, bool> survivalModeSelections;
  final VoidCallback onSelectionsChanged;

  const WorkoutCard({
    super.key,
    required this.workout,
    required this.formatTime,
    required this.showLevelSelectionBottomSheet,
    required this.deleteWorkout,
    required this.levelSelections,
    required this.survivalModeSelections,
    required this.onSelectionsChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            WorkoutCardHeader(
              workout: workout,
              formatTime: formatTime,
            ),
            const SizedBox(height: 16),
            WorkoutPlan(items: workout.items),
            const SizedBox(height: 16),
            WorkoutCardControls(
              workout: workout,
              showLevelSelectionBottomSheet: showLevelSelectionBottomSheet,
              deleteWorkout: deleteWorkout,
              levelSelections: levelSelections,
              survivalModeSelections: survivalModeSelections,
              onSelectionsChanged: onSelectionsChanged,
            ),
          ],
        ),
      ),
    );
  }
}
