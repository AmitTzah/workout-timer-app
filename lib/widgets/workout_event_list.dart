import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:workout_timer_app/models/workout_summary.dart';
import 'package:workout_timer_app/screens/workout_summaries_screen.dart';

class WorkoutEventList extends StatelessWidget {
  final List<WorkoutSummary> events;
  final Function(WorkoutSummary)? onNavigateToHistory;

  const WorkoutEventList({super.key, required this.events, this.onNavigateToHistory});

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '${twoDigits(duration.inHours)}:$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    if (events.isEmpty) {
      return const Center(
        child: Text("No workouts for this day"),
      );
    }
    return ListView.builder(
      itemCount: events.length,
      itemBuilder: (context, index) {
        final summary = events[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          child: ListTile(
            title: Text(summary.workoutName),
            subtitle: Text(
                '${DateFormat.yMMMd().add_jm().format(summary.date)} - ${_formatDuration(summary.totalDuration)}'),
            onTap: () {
              if (onNavigateToHistory != null) {
                onNavigateToHistory!(summary);
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        WorkoutSummariesScreen(highlightedSummary: summary),
                  ),
                );
              }
            },
          ),
        );
      },
    );
  }
}
