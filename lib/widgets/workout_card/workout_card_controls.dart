import 'package:flutter/material.dart';
import 'package:exercise_timer_app/models/user_workout.dart';
import 'package:exercise_timer_app/repositories/user_workout_repository.dart';
import 'package:exercise_timer_app/screens/define_workout_screen.dart';
import 'package:exercise_timer_app/screens/workout_screen.dart';
import 'package:provider/provider.dart';

class WorkoutCardControls extends StatelessWidget {
  final UserWorkout workout;
  final Function(BuildContext, dynamic, UserWorkout)
      showLevelSelectionBottomSheet;
  final Function(String) deleteWorkout;
  final Map<String, int> levelSelections;
  final Map<String, bool> survivalModeSelections;
  final VoidCallback onSelectionsChanged;

  const WorkoutCardControls({
    super.key,
    required this.workout,
    required this.showLevelSelectionBottomSheet,
    required this.deleteWorkout,
    required this.levelSelections,
    required this.survivalModeSelections,
    required this.onSelectionsChanged,
  });

  @override
  Widget build(BuildContext context) {
    final userWorkoutRepository = Provider.of<UserWorkoutRepository>(context);
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton.icon(
                onPressed: () async {
                  final int? selectedValue =
                      await showLevelSelectionBottomSheet(
                    context,
                    levelSelections[workout.id] ?? 1,
                    workout,
                  );
                  if (selectedValue != null) {
                    levelSelections[workout.id] = selectedValue;
                    workout.selectedLevel = selectedValue;
                    await userWorkoutRepository
                        .saveUserWorkout(workout);
                    onSelectionsChanged();
                  }
                },
                icon: const Icon(Icons.leaderboard),
                label: Text(
                  'Level: L${levelSelections[workout.id] ?? 1} (+${((levelSelections[workout.id] ?? 1) == 1 ? 0 : (((((levelSelections[workout.id] ?? 1) - 1) * 20))))}%)',
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  bool currentValue =
                      survivalModeSelections[workout.id] ?? false;
                  survivalModeSelections[workout.id] =
                      !currentValue;
                  workout.selectedSurvivalMode = !currentValue;
                  userWorkoutRepository.saveUserWorkout(workout);
                  onSelectionsChanged();
                },
                icon: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder:
                      (Widget child, Animation<double> animation) {
                    return ScaleTransition(scale: animation, child: child);
                  },
                  child: Icon(
                    survivalModeSelections[workout.id] ?? false
                        ? Icons.check_box
                        : Icons.check_box_outline_blank,
                    key: ValueKey<bool>(
                        survivalModeSelections[workout.id] ??
                            false),
                  ),
                ),
                label: const Text('Survival'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton.icon(
                icon: const Icon(Icons.play_arrow),
                label: const Text("Start"),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => WorkoutScreen(
                        workout: workout,
                        workoutType: workout.workoutType,
                        selectedLevelOrMode:
                            survivalModeSelections[workout.id] ==
                                    true
                                ? "survival"
                                : (levelSelections[workout.id] ??
                                    1),
                      ),
                    ),
                  );
                },
              ),
              ElevatedButton.icon(
                icon: const Icon(Icons.edit),
                label: const Text("Edit"),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>
                          DefineWorkoutScreen(workout: workout),
                    ),
                  );
                },
              ),
              ElevatedButton.icon(
                icon: const Icon(Icons.delete),
                label: const Text("Delete"),
                onPressed: () => deleteWorkout(workout.id),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
