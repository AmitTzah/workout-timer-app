import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_timer_app/models/workout_summary.dart';
import 'package:workout_timer_app/repositories/workout_summary_repository.dart';
import 'package:workout_timer_app/screens/workout_calendar_screen.dart';
import 'package:workout_timer_app/widgets/workout_summary/workout_summary_details_card.dart';

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
    if (widget.highlightedSummary != null) {
      _expandedWorkoutName = widget.highlightedSummary!.workoutName;
    }
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
    for (final key in grouped.keys) {
      grouped[key]!.sort((a, b) => b.date.compareTo(a.date));
    }
    return grouped;
  }

  Future<void> _saveNote(WorkoutSummary summary, String note) async {
    final updatedSummary = WorkoutSummary(
      id: summary.id,
      date: summary.date,
      performedSets: summary.performedSets,
      totalDurationInSeconds: summary.totalDurationInSeconds,
      workoutName: summary.workoutName,
      workoutLevel: summary.workoutLevel,
      isSurvivalMode: summary.isSurvivalMode,
      workoutType: summary.workoutType,
      wasStoppedPrematurely: summary.wasStoppedPrematurely,
      totalSets: summary.totalSets,
      completionDetails: summary.completionDetails,
      notes: note.isEmpty ? null : note,
    );
    await _workoutSummaryRepository.saveWorkoutSummary(updatedSummary);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(note.isEmpty ? 'Note cleared' : 'Note saved!'),
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
                  title: Row(
                    children: [
                      Text(
                        workoutName,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      if (workoutSummaries.any((s) => s.notes != null && s.notes!.isNotEmpty))
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Icon(Icons.notes, size: 20, color: Theme.of(context).colorScheme.primary),
                        ),
                    ],
                  ),
                  subtitle: Text('${workoutSummaries.length} workout(s)'),
                  children: workoutSummaries.map((summary) {
                    return WorkoutSummaryDetailsCard(
                      summary: summary,
                      onDelete: (id) {
                        _workoutSummaryRepository.deleteWorkoutSummary(id);
                      },
                      onSaveNote: _saveNote,
                    );
                  }).toList(),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
