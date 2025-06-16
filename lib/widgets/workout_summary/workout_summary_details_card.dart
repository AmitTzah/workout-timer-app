import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:workout_timer_app/models/workout_summary.dart';
import 'package:workout_timer_app/widgets/workout_summary/note_display.dart';
import 'package:workout_timer_app/widgets/workout_summary/note_edit_dialog.dart';

class WorkoutSummaryDetailsCard extends StatefulWidget {
  final WorkoutSummary summary;
  final Function(int) onDelete;
  final Function(WorkoutSummary, String) onSaveNote;

  const WorkoutSummaryDetailsCard({
    super.key,
    required this.summary,
    required this.onDelete,
    required this.onSaveNote,
  });

  @override
  State<WorkoutSummaryDetailsCard> createState() => _WorkoutSummaryDetailsCardState();
}

class _WorkoutSummaryDetailsCardState extends State<WorkoutSummaryDetailsCard> {
  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '${twoDigits(duration.inHours)}:$minutes:$seconds';
  }

  Future<bool?> _confirmDismiss(BuildContext context, String workoutName) async {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: Text('Are you sure you want to delete this workout summary?'),
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

  void _showNoteEditDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return NoteEditDialog(
          initialNote: widget.summary.notes ?? '',
          characterLimit: 1000,
          onSave: (note) {
            widget.onSaveNote(widget.summary, note);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey('${widget.summary.workoutName}-${widget.summary.date.toIso8601String()}'),
      direction: DismissDirection.endToStart,
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      confirmDismiss: (direction) => _confirmDismiss(context, widget.summary.workoutName),
      onDismissed: (direction) {
        widget.onDelete(widget.summary.id!);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Workout summary for "${widget.summary.workoutName}" deleted'),
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
                'Date: ${DateFormat('yyyy-MM-dd HH:mm').format(widget.summary.date)}',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Text('Duration: ${_formatDuration(widget.summary.totalDuration)}'),
              if (widget.summary.workoutLevel > 1)
                Text('Level: ${widget.summary.workoutLevel}'),
              if (widget.summary.isSurvivalMode) const Text('Mode: Survival'),
              Text(
                'Sets Order: ${widget.summary.workoutType.toString().split('.').last == 'alternating' ? 'Alternating' : 'Sequential'}',
              ),
              Text('Total Sets Performed: ${widget.summary.totalSets}'),
              if (widget.summary.wasStoppedPrematurely)
                const Text('Status: Stopped Early'),
              const SizedBox(height: 16),
              ExpansionTile(
                title: Text(
                  'Workout Plan Performed',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                subtitle: const Text('Tap to see details'),
                collapsedBackgroundColor: Colors.blue[50],
                backgroundColor: Colors.blue[100],
                iconColor: Colors.blue[800],
                collapsedIconColor: Colors.blue[800],
                tilePadding: const EdgeInsets.symmetric(horizontal: 16.0),
                childrenPadding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ),
                children: widget.summary.performedSets.map((workoutSet) {
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
                    key: ValueKey(workoutSet.id),
                    padding: const EdgeInsets.only(left: 16.0, bottom: 8.0),
                    child: Text(content, style: style),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              widget.summary.notes != null && widget.summary.notes!.isNotEmpty
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Notes:',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: _showNoteEditDialog,
                              tooltip: 'Edit Note',
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        NoteDisplay(note: widget.summary.notes!),
                      ],
                    )
                  : Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton.icon(
                        icon: const Icon(Icons.add),
                        label: const Text('Add Workout Note'),
                        onPressed: _showNoteEditDialog,
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}