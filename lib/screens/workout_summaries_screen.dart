import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_timer_app/models/workout_summary.dart';
import 'package:workout_timer_app/repositories/workout_summary_repository.dart';
import 'package:workout_timer_app/screens/workout_calendar_screen.dart'; // Use the new repository
// Import WorkoutType

import 'package:intl/intl.dart'; // For date formatting

class WorkoutSummariesScreen extends StatefulWidget {
  final WorkoutSummary? highlightedSummary;
  const WorkoutSummariesScreen({super.key, this.highlightedSummary});

  @override
  State<WorkoutSummariesScreen> createState() => _WorkoutSummariesScreenState();
}

class _WorkoutSummariesScreenState extends State<WorkoutSummariesScreen> {
  late WorkoutSummaryRepository _workoutSummaryRepository;
  final ScrollController _scrollController = ScrollController();
  String? _expandedWorkoutName;
  late Map<String, List<WorkoutSummary>> _groupedSummaries;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _workoutSummaryRepository = Provider.of<WorkoutSummaryRepository>(context);
    // No longer initialize _groupedSummaries here, it will be handled by StreamBuilder
    if (widget.highlightedSummary != null) {
      _expandedWorkoutName = widget.highlightedSummary!.workoutName;
    }
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '${twoDigits(duration.inHours)}:$minutes:$seconds';
  }

  Future<bool?> _confirmDismiss(
    BuildContext context,
    String workoutName, {
    bool deleteAll = false,
  }) async {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Deletion'),
          content: Text(
            deleteAll
                ? 'Are you sure you want to delete all summaries for "$workoutName"?'
                : 'Are you sure you want to delete this workout summary?',
          ),
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


  Map<String, List<WorkoutSummary>> _groupSummaries(
    List<WorkoutSummary> summaries,
  ) {
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
      key: ValueKey('${summary.workoutName}-${summary.date.toIso8601String()}'), // Assign a truly unique key
      direction: DismissDirection.endToStart,
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      confirmDismiss: (direction) =>
          _confirmDismiss(context, summary.workoutName),
      onDismissed: (direction) {
        _workoutSummaryRepository.deleteWorkoutSummary(summary.id!);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Workout summary for "${summary.workoutName}" deleted',
            ),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Date: ${DateFormat('yyyy-MM-dd HH:mm').format(summary.date)}',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Text('Duration: ${_formatDuration(summary.totalDuration)}'),
              if (summary.workoutLevel > 1)
                Text('Level: ${summary.workoutLevel}'),
              if (summary.isSurvivalMode) const Text('Mode: Survival'),
              Text(
                'Sets Order: ${summary.workoutType.toString().split('.').last == 'alternating' ? 'Alternating' : 'Sequential'}',
              ),
              Text('Total Sets Performed: ${summary.totalSets}'),
              if (summary.wasStoppedPrematurely)
                const Text('Status: Stopped Early'),
              const SizedBox(height: 16),
              ExpansionTile(
                title: Text(
                  'Workout Plan Performed',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text('Tap to see details'),
                collapsedBackgroundColor: Colors.blue[50],
                backgroundColor: Colors.blue[100],
                iconColor: Colors.blue[800],
                collapsedIconColor: Colors.blue[800],
                tilePadding: const EdgeInsets.symmetric(horizontal: 16.0),
                childrenPadding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ),
                children: summary.performedSets.map((workoutSet) {
                  final content = workoutSet.isRestBlock
                      ? '- Rest Block (${workoutSet.restBlockDuration}s)'
                      : workoutSet.isRestSet
                      ? '- Rest (after ${workoutSet.exercise.name} Set ${workoutSet.setNumber}) Duration: ${workoutSet.exercise.restTimeInSeconds ?? 0}s'
                      : '- ${workoutSet.exercise.name} (Set ${workoutSet.setNumber} / ${workoutSet.exercise.sets})'
                            '${workoutSet.exercise.reps != null ? ', Reps: ${workoutSet.exercise.reps}' : ''}'
                            ' | Work: ${workoutSet.exercise.workTimeInSeconds}s';

                  final style = workoutSet.isRestBlock || workoutSet.isRestSet
                      ? Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontStyle: FontStyle.italic,
                        )
                      : Theme.of(context).textTheme.bodyLarge;

                  return Padding(
                    key: ValueKey(workoutSet.id), // Add unique key here
                    padding: const EdgeInsets.only(left: 16.0, bottom: 8.0),
                    child: Text(content, style: style),
                  );
                }).toList(),
              ),
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
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const WorkoutCalendarScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: StreamBuilder<List<WorkoutSummary>>(
        stream: _workoutSummaryRepository.watchAllWorkoutSummaries(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final summaries = snapshot.data ?? [];
          if (summaries.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  'No workout summaries yet. Complete a workout to see it here!',
                  textAlign: TextAlign.center,
                  style: Theme.of(
                    context,
                  ).textTheme.headlineSmall?.copyWith(color: Colors.grey),
                ),
              ),
            );
          }
          _groupedSummaries = _groupSummaries(summaries);
          final sortedWorkoutNames = _groupedSummaries.keys.toList()
            ..sort(
              (a, b) => _groupedSummaries[b]!.first.date.compareTo(
                    _groupedSummaries[a]!.first.date,
                  ),
            );


          return ListView.builder(
            controller: _scrollController,
            itemCount: sortedWorkoutNames.length,
            itemBuilder: (context, index) {
              final workoutName = sortedWorkoutNames[index];
              final workoutSummaries = _groupedSummaries[workoutName]!;
              return Card(
                margin: const EdgeInsets.all(8.0),
                child: ExpansionTile(
                  key: ValueKey(workoutName),
                  initiallyExpanded: workoutName == _expandedWorkoutName,
                  onExpansionChanged: (isExpanded) {
                    setState(() {
                      if (isExpanded) {
                        _expandedWorkoutName = workoutName;
                      } else if (_expandedWorkoutName == workoutName) {
                        _expandedWorkoutName = null;
                      }
                    });
                  },
                  title: Text(
                    workoutName,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  subtitle: Text('${workoutSummaries.length} workout(s)'),
                  children:
                      workoutSummaries.map(_buildSummaryDetails).toList(),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
