import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Import provider
import 'package:workout_timer_app/models/workout_summary.dart';
import 'package:workout_timer_app/repositories/workout_summary_repository.dart'; // Use the new repository
import 'package:intl/intl.dart'; // For date formatting

class WorkoutSummaryDisplayScreen extends StatefulWidget {
  final WorkoutSummary summary;

  const WorkoutSummaryDisplayScreen({
    super.key,
    required this.summary,
  });

  @override
  State<WorkoutSummaryDisplayScreen> createState() => _WorkoutSummaryDisplayScreenState();
}

class _WorkoutSummaryDisplayScreenState extends State<WorkoutSummaryDisplayScreen> {
  final TextEditingController _noteTextController = TextEditingController();
  static const int _characterLimit = 1000;

  @override
  void initState() {
    super.initState();
    _noteTextController.text = widget.summary.notes ?? '';
  }

  @override
  void dispose() {
    _noteTextController.dispose();
    super.dispose();
  }


  String _formatDuration(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final remainingSeconds = (seconds % 60).toString().padLeft(2, '0');
    return '$minutes:$remainingSeconds';
  }

  Widget _buildSummaryRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 150, // Fixed width for labels
            child: Text(
              label,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Workout Summary'),
        automaticallyImplyLeading: false, // No back button
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          // Wrap with SingleChildScrollView
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.summary.wasStoppedPrematurely
                    ? 'Workout Stopped Early!'
                    : (widget.summary.isSurvivalMode
                        ? 'Survival Workout Ended!'
                        : 'Workout Complete!'),
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 20),
              _buildSummaryRow(context, 'Workout Name:', widget.summary.workoutName),
              _buildSummaryRow(
                  context, 'Date:', DateFormat('yyyy-MM-dd HH:mm').format(widget.summary.date)),
              _buildSummaryRow(context, 'Total Duration:',
                  _formatDuration(widget.summary.totalDurationInSeconds)),
              _buildSummaryRow(
                  context, 'Workout Level:', widget.summary.workoutLevel.toString()),
              _buildSummaryRow(
                  context,
                  'Sets Order:',
                  widget.summary.workoutType.toString().split('.').last ==
                          'alternating'
                      ? 'Alternating'
                      : 'Sequential'),
              _buildSummaryRow(
                  context, 'Total Sets Performed:', widget.summary.totalSets.toString()),
              const SizedBox(height: 20),
              TextFormField(
                controller: _noteTextController,
                maxLines: null,
                keyboardType: TextInputType.multiline,
                maxLength: _characterLimit,
                decoration: const InputDecoration(
                  hintText: 'How did it feel? Note any PBs, pain, or equipment used.',
                  labelText: 'Workout Note',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              ExpansionTile(
                initiallyExpanded: true,
                title: Text(
                  'Workout Plan Performed:',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    // Important for ListView inside SingleChildScrollView
                    physics: const NeverScrollableScrollPhysics(),
                    // Disable ListView's own scrolling
                    itemCount: widget.summary.performedSets.length,
                    itemBuilder: (context, index) {
                      final workoutSet = widget.summary.performedSets[index];
                      if (workoutSet.isRestBlock) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 4.0, horizontal: 16.0),
                          child: Text(
                            '- Rest Block (${workoutSet.restBlockDuration}s)',
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge
                                ?.copyWith(fontStyle: FontStyle.italic),
                          ),
                        );
                      } else if (workoutSet.isRestSet) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 4.0, horizontal: 16.0),
                          child: Text(
                            '- Rest (after ${workoutSet.exercise.name} Set ${workoutSet.setNumber}) Duration: ${workoutSet.exercise.restTimeInSeconds ?? 0}s',
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge
                                ?.copyWith(fontStyle: FontStyle.italic),
                          ),
                        );
                      } else {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 4.0, horizontal: 16.0),
                          child: Text(
                            '- ${workoutSet.exercise.name} (Set ${workoutSet.setNumber} / ${workoutSet.exercise.sets})'
                            '${workoutSet.exercise.reps != null ? ', Reps: ${workoutSet.exercise.reps}' : ''}'
                            ' | Work: ${workoutSet.exercise.workTimeInSeconds}s',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 16.0),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context)
                              .popUntil((route) => route.isFirst); // Go back to setup screen
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        child: const Text(
                          'Discard Workout',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                      const SizedBox(width: 16),
                      ElevatedButton(
                        onPressed: () async {
                          final workoutSummaryRepository =
                              Provider.of<WorkoutSummaryRepository>(context, listen: false);
                          final updatedSummary = WorkoutSummary(
                            id: widget.summary.id,
                            date: widget.summary.date,
                            performedSets: widget.summary.performedSets,
                            totalDurationInSeconds: widget.summary.totalDurationInSeconds,
                            workoutName: widget.summary.workoutName,
                            workoutLevel: widget.summary.workoutLevel,
                            isSurvivalMode: widget.summary.isSurvivalMode,
                            workoutType: widget.summary.workoutType,
                            wasStoppedPrematurely: widget.summary.wasStoppedPrematurely,
                            totalSets: widget.summary.totalSets,
                            completionDetails: widget.summary.completionDetails,
                            notes: _noteTextController.text.isEmpty ? null : _noteTextController.text,
                          );
                          await workoutSummaryRepository.saveWorkoutSummary(updatedSummary);
                          if (!context.mounted) return;
                          Navigator.of(context)
                              .popUntil((route) => route.isFirst); // Go back to setup screen
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                        ),
                        child: const Text(
                          'Save Workout',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
