import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hive/hive.dart'; // Keep Hive import for Box type
import 'package:exercise_timer_app/models/workout_summary.dart';
import 'package:exercise_timer_app/repositories/workout_summary_repository.dart'; // Use the new repository
// Import WorkoutType

import 'package:intl/intl.dart'; // For date formatting

class WorkoutSummariesScreen extends StatefulWidget {
  const WorkoutSummariesScreen({super.key});

  @override
  State<WorkoutSummariesScreen> createState() => _WorkoutSummariesScreenState();
}

class _WorkoutSummariesScreenState extends State<WorkoutSummariesScreen> {
  late WorkoutSummaryRepository _workoutSummaryRepository;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _workoutSummaryRepository = Provider.of<WorkoutSummaryRepository>(context);
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '${twoDigits(duration.inHours)}:$minutes:$seconds';
  }


  Future<bool?> _confirmDismiss(BuildContext context, String workoutName, {bool deleteAll = false}) async {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Deletion'),
          content: Text(deleteAll
              ? 'Are you sure you want to delete all summaries for "$workoutName"?'
              : 'Are you sure you want to delete this workout summary?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  Map<String, List<WorkoutSummary>> _groupSummaries(List<WorkoutSummary> summaries) {
    final Map<String, List<WorkoutSummary>> grouped = {};
    for (final summary in summaries) {
      if (grouped.containsKey(summary.workoutName)) {
        grouped[summary.workoutName]!.add(summary);
      } else {
        grouped[summary.workoutName] = [summary];
      }
    }
    // Sort summaries within each group by date, newest first
    for (final key in grouped.keys) {
      grouped[key]!.sort((a, b) => b.date.compareTo(a.date));
    }
    return grouped;
  }

  Widget _buildSummaryDetails(WorkoutSummary summary) {
    return Dismissible(
      key: ValueKey(summary.key),
      direction: DismissDirection.endToStart,
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      confirmDismiss: (direction) => _confirmDismiss(context, summary.workoutName),
      onDismissed: (direction) {
        _workoutSummaryRepository.deleteWorkoutSummary(summary.key);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Workout summary for "${summary.workoutName}" deleted')),
        );
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Date: ${DateFormat('yyyy-MM-dd HH:mm').format(summary.date)}', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              Text('Duration: ${_formatDuration(summary.totalDuration)}'),
              if (summary.workoutLevel > 1) Text('Level: ${summary.workoutLevel}'),
              if (summary.isSurvivalMode) const Text('Mode: Survival'),
              Text('Sets Order: ${summary.workoutType.toString().split('.').last == 'alternating' ? 'Alternating' : 'Sequential'}'),
              Text('Total Sets Performed: ${summary.totalSets}'),
              if (summary.wasStoppedPrematurely) const Text('Status: Stopped Early'),
              const SizedBox(height: 16),
              Text(
                'Workout Plan Performed:',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ...summary.performedSets.map((workoutSet) {
                if (workoutSet.isRestBlock) {
                  return Text(
                    '- Rest Block (${workoutSet.restBlockDuration}s)',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontStyle: FontStyle.italic),
                  );
                } else if (workoutSet.isRestSet) {
                  return Text(
                    '- Rest (after ${workoutSet.exercise.name} Set ${workoutSet.setNumber}) Duration: ${workoutSet.exercise.restTimeInSeconds ?? 0}s',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontStyle: FontStyle.italic),
                  );
                } else {
                  return Text(
                    '- ${workoutSet.exercise.name} (Set ${workoutSet.setNumber} / ${workoutSet.exercise.sets})'
                    '${workoutSet.exercise.reps != null ? ', Reps: ${workoutSet.exercise.reps}' : ''}'
                    ' | Work: ${workoutSet.exercise.workTimeInSeconds}s',
                    style: Theme.of(context).textTheme.bodyLarge,
                  );
                }
              }),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Workout Summaries'),
      ),
      body: ValueListenableBuilder(
        valueListenable: _workoutSummaryRepository.listenable,
        builder: (context, Box<WorkoutSummary> box, _) {
          if (box.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  'No workout summaries yet. Complete a workout to see it here!',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.grey),
                ),
              ),
            );
          }
          final List<WorkoutSummary> summaries = box.values.toList().cast<WorkoutSummary>();
          final groupedSummaries = _groupSummaries(summaries);
          final sortedWorkoutNames = groupedSummaries.keys.toList()
            ..sort((a, b) => groupedSummaries[b]!.first.date.compareTo(groupedSummaries[a]!.first.date));

          return ListView.builder(
            itemCount: sortedWorkoutNames.length,
            itemBuilder: (context, index) {
              final workoutName = sortedWorkoutNames[index];
              final workoutSummaries = groupedSummaries[workoutName]!;
              return Dismissible(
                key: ValueKey(workoutName),
                direction: DismissDirection.endToStart,
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                confirmDismiss: (direction) => _confirmDismiss(context, workoutName, deleteAll: true),
                onDismissed: (direction) {
                  for (final summary in workoutSummaries) {
                    _workoutSummaryRepository.deleteWorkoutSummary(summary.key);
                  }
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('All summaries for "$workoutName" deleted')),
                  );
                },
                child: Card(
                  margin: const EdgeInsets.all(8.0),
                  child: ExpansionTile(
                    title: Text(
                      workoutName,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text('${workoutSummaries.length} workout(s)'),
                    children: workoutSummaries.map(_buildSummaryDetails).toList(),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
