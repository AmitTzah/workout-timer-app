import 'package:flutter/material.dart';
import 'package:workout_timer_app/models/workout_item.dart';
import 'package:workout_timer_app/models/rest_block_item.dart';
import 'package:workout_timer_app/models/alternating_group_item.dart';
import 'package:workout_timer_app/models/exercise.dart';

class WorkoutPlan extends StatelessWidget {
  final List<WorkoutItem> items;

  const WorkoutPlan({
    super.key,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Workout Plan:',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        ...items.map((item) {
          if (item is Exercise) {
            return _buildExerciseItem(item);
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
          ...group.exercises.map((e) => _buildExerciseItem(e)),
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
}
