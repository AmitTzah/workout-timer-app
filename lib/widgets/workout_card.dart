import 'package:flutter/material.dart';
import 'package:exercise_timer_app/models/user_workout.dart';
import 'package:exercise_timer_app/models/workout_type.dart';
import 'package:exercise_timer_app/repositories/user_workout_repository.dart';
import 'package:exercise_timer_app/screens/define_workout_screen.dart';
import 'package:exercise_timer_app/screens/workout_screen.dart';
import 'package:provider/provider.dart';
import 'package:exercise_timer_app/models/workout_item.dart';
import 'package:exercise_timer_app/models/rest_block_item.dart';
import 'package:exercise_timer_app/models/alternating_group_item.dart';
import 'package:exercise_timer_app/models/exercise.dart';
import 'package:exercise_timer_app/models/workout_item.dart';

class WorkoutCard extends StatefulWidget {
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
  State<WorkoutCard> createState() => _WorkoutCardState();
}

class _WorkoutCardState extends State<WorkoutCard> {
  late UserWorkoutRepository _userWorkoutRepository;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _userWorkoutRepository = Provider.of<UserWorkoutRepository>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildWorkoutHeader(context),
            const SizedBox(height: 16),
            _buildWorkoutSequence(context),
            const SizedBox(height: 16),
            _buildControlsSection(context),
            const SizedBox(height: 16),
            _buildActionButtons(context),
          ],
        ),
      ),
    );
  }

  Widget _buildWorkoutHeader(BuildContext context) {
    final workoutType = widget.workout.workoutType;
    final typeText = workoutType.toString().split('.').last;
    final typeColor = workoutType == WorkoutType.sequential
        ? Colors.blue
        : Colors.deepPurpleAccent.shade100;

    int totalSetsOrCycles = 0;
    if (workoutType == WorkoutType.sequential) {
      totalSetsOrCycles = widget.workout.items
          .whereType<ExerciseItem>()
          .fold(0, (sum, item) => sum + item.exercise.sets);
    } else if (workoutType == WorkoutType.alternating) {
      totalSetsOrCycles = widget.workout.items
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
              widget.workout.name,
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
            'Total Time: ${widget.formatTime(widget.workout.totalWorkoutTime, includeHours: true)}'),
        const SizedBox(height: 4),
        Text('Total ${workoutType == WorkoutType.sequential ? "Sets" : "Cycles"}: $totalSetsOrCycles'),
      ],
    );
  }

  Widget _buildWorkoutSequence(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Workout Sequence:',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        ...widget.workout.items.map((item) {
          if (item is ExerciseItem) {
            return _buildExerciseItem(item.exercise);
          } else if (item is AlternatingGroupItem) {
            return _buildAlternatingGroupItem(item);
          } else if (item is RestBlockItem) {
            return _buildRestBlockItem(item);
          }
          return Container();
        }),
      ],
    );
  }

  Widget _buildExerciseItem(Exercise exercise) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, bottom: 4.0),
      child: Text(
        '• ${exercise.name} (${exercise.sets}x${exercise.reps ?? ''}) '
        '[Work: ${exercise.workTimeInSeconds}s'
        '${exercise.restTimeInSeconds != null ? ', Rest: ${exercise.restTimeInSeconds}s' : ''}]',
      ),
    );
  }

  Widget _buildAlternatingGroupItem(AlternatingGroupItem group) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${group.name} (${group.cycles} Cycles)'
            '${group.groupRestInSeconds != null ? ' [Rest: ${group.groupRestInSeconds}s]' : ''}',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          ...group.exercises.map((e) => _buildExerciseItem(e)).toList(),
        ],
      ),
    );
  }

  Widget _buildRestBlockItem(RestBlockItem item) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, bottom: 4.0),
      child: Text(
        '• Rest Block (${item.durationInSeconds}s)',
        style: const TextStyle(fontStyle: FontStyle.italic),
      ),
    );
  }

  Widget _buildControlsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () async {
            final int? selectedValue =
                await widget.showLevelSelectionBottomSheet(
              context,
              widget.levelSelections[widget.workout.id] ?? 1,
              widget.workout,
            );
            if (selectedValue != null) {
              widget.levelSelections[widget.workout.id] = selectedValue;
              widget.workout.selectedLevel = selectedValue;
              await _userWorkoutRepository.saveUserWorkout(widget.workout);
              widget.onSelectionsChanged();
            }
          },
          child: Container(
            padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(4.0),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Level: L${widget.levelSelections[widget.workout.id] ?? 1} (+${((widget.levelSelections[widget.workout.id] ?? 1) == 1 ? 0 : (((((widget.levelSelections[widget.workout.id] ?? 1) - 1) * 20))))}%)',
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(width: 8),
                const Icon(Icons.arrow_drop_down),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Checkbox(
              value: widget.survivalModeSelections[widget.workout.id] ?? false,
              onChanged: (bool? newValue) async {
                widget.survivalModeSelections[widget.workout.id] =
                    newValue ?? false;
                widget.workout.selectedSurvivalMode = newValue ?? false;
                await _userWorkoutRepository.saveUserWorkout(widget.workout);
                widget.onSelectionsChanged();
              },
            ),
            const Text('Survival Mode'),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        ElevatedButton.icon(
          icon: const Icon(Icons.play_arrow),
          label: const Text("Start"),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => WorkoutScreen(
                  workout: widget.workout,
                  workoutType: widget.workout.workoutType,
                  selectedLevelOrMode:
                      widget.survivalModeSelections[widget.workout.id] == true
                          ? "survival"
                          : (widget.levelSelections[widget.workout.id] ?? 1),
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
                    DefineWorkoutScreen(workout: widget.workout),
              ),
            );
          },
        ),
        ElevatedButton.icon(
          icon: const Icon(Icons.delete),
          label: const Text("Delete"),
          onPressed: () => widget.deleteWorkout(widget.workout.id),
        ),
      ],
    );
  }
}
