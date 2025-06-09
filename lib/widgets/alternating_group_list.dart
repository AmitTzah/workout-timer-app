import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:workout_timer_app/models/alternating_group_item.dart';
import 'package:workout_timer_app/models/exercise.dart';
import 'package:workout_timer_app/models/workout_item.dart';
import 'package:workout_timer_app/models/rest_block_item.dart';

class AlternatingGroupList extends StatefulWidget {
  final List<WorkoutItem> workoutItems;
  final Function(int oldIndex, int newIndex) onReorderItems;
  final Function(String groupId, int oldExerciseIndex, int newExerciseIndex)
  onReorderExercisesInGroup;
  final Function(String groupId, Exercise exercise) onAddExerciseToGroup;
  final Function(String groupId, int exerciseIndex) onRemoveExerciseFromGroup;
  final Function(String groupId, int exerciseIndex, Exercise updatedExercise)
  onEditExerciseInGroup;
  final Function(String id) onRemoveItem; // Changed to onRemoveItem with ID
  final Function() onAddGroup;
  final List<String> predefinedExercises;
  final Function(String id, String newName, int newCycles, int? newGroupRest)
  onEditGroup; // New callback for editing group

  const AlternatingGroupList({
    super.key,
    required this.workoutItems,
    required this.onReorderItems,
    required this.onReorderExercisesInGroup,
    required this.onAddExerciseToGroup,
    required this.onRemoveExerciseFromGroup,
    required this.onEditExerciseInGroup,
    required this.onRemoveItem,
    required this.onAddGroup,
    required this.predefinedExercises,
    required this.onEditGroup,
  });

  @override
  State<AlternatingGroupList> createState() => _AlternatingGroupListState();
}

class _AlternatingGroupListState extends State<AlternatingGroupList> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ReorderableListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: widget.workoutItems.length,
          onReorder: widget.onReorderItems,
          itemBuilder: (context, index) {
            final item = widget.workoutItems[index];

            if (item is AlternatingGroupItem) {
              final group = item;
              return Card(
                key: ValueKey(group.id),
                margin: const EdgeInsets.symmetric(
                  vertical: 8.0,
                  horizontal: 4.0,
                ), // Add horizontal margin
                elevation: 4.0, // Add elevation for a raised effect
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () async {
                              await _showEditGroupNameDialog(context, group);
                            },
                            splashColor: Theme.of(context).colorScheme.primary
                                .withAlpha(
                                  (255 * 0.3).round(),
                                ), // Increased opacity
                            highlightColor: Theme.of(context)
                                .colorScheme
                                .primary
                                .withAlpha(
                                  (255 * 0.15).round(),
                                ), // Increased opacity
                            borderRadius: BorderRadius.circular(
                              8.0,
                            ), // Add border radius
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 4.0,
                                horizontal: 8.0,
                              ), // Add some padding for better tap area
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    group.name,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  const Icon(Icons.edit, size: 18),
                                ],
                              ),
                            ),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () => widget.onRemoveItem(group.id),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const Divider(),
                      // Layout for Cycles and Rest between cycles, with main edit icon for group
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment
                              .spaceAround, // Reverted to spaceAround to distribute the two centered columns
                          children: [
                            Center(
                              // Explicitly center the Cycles column
                              child: InkWell(
                                onTap: () async {
                                  await _showEditCyclesDialog(context, group);
                                },
                                splashColor: Theme.of(context)
                                    .colorScheme
                                    .primary
                                    .withAlpha((255 * 0.3).round()),
                                highlightColor: Theme.of(context)
                                    .colorScheme
                                    .primary
                                    .withAlpha((255 * 0.15).round()),
                                borderRadius: BorderRadius.circular(8.0),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 4.0,
                                    horizontal: 8.0,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Text(
                                            'Cycles',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(width: 4),
                                          const Icon(Icons.edit, size: 16),
                                        ],
                                      ),
                                      Text('${group.cycles}'),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Center(
                              // Explicitly center the Rest Between Cycles column
                              child: InkWell(
                                onTap: () async {
                                  await _showEditGroupRestDialog(
                                    context,
                                    group,
                                  );
                                },
                                splashColor: Theme.of(context)
                                    .colorScheme
                                    .primary
                                    .withAlpha((255 * 0.3).round()),
                                highlightColor: Theme.of(context)
                                    .colorScheme
                                    .primary
                                    .withAlpha((255 * 0.15).round()),
                                borderRadius: BorderRadius.circular(8.0),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 4.0,
                                    horizontal: 8.0,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Text(
                                            'Rest Between Cycles',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(width: 4),
                                          const Icon(Icons.edit, size: 16),
                                        ],
                                      ),
                                      Text('${group.groupRestInSeconds ?? 0}s'),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      ReorderableListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: group.exercises.length,
                        onReorder: (oldExerciseIndex, newExerciseIndex) {
                          widget.onReorderExercisesInGroup(
                            group.id,
                            oldExerciseIndex,
                            newExerciseIndex,
                          );
                        },
                        itemBuilder: (context, exerciseIndex) {
                          final exercise = group.exercises[exerciseIndex];
                          return Card(
                            // Wrap ListTile in Card for raised effect
                            key: ValueKey(
                              exercise.id,
                            ), // Key needs to be on the Card for ReorderableListView
                            margin: const EdgeInsets.symmetric(
                              vertical: 4.0,
                              horizontal: 8.0,
                            ), // Add horizontal margin
                            elevation: 2.0, // Add elevation for a raised effect
                            child: ListTile(
                              leading: const Icon(
                                Icons.drag_handle,
                              ), // Drag handle
                              title: Text(exercise.name),
                              subtitle: Text(
                                '${exercise.reps != null ? 'Reps: ${exercise.reps} | ' : ''}'
                                'Work: ${exercise.workTimeInSeconds}s | Rest: ${exercise.restTimeInSeconds ?? 'N/A'}s',
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit),
                                    onPressed: () async {
                                      final Exercise? updatedExercise =
                                          await _showEditExerciseDialog(
                                            context,
                                            exercise,
                                          );
                                      if (updatedExercise != null) {
                                        widget.onEditExerciseInGroup(
                                          group.id,
                                          exerciseIndex,
                                          updatedExercise,
                                        );
                                      }
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete),
                                    onPressed: () =>
                                        widget.onRemoveExerciseFromGroup(
                                          group.id,
                                          exerciseIndex,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                      // Repositioned and styled "Add Exercise to Group" button
                      const SizedBox(height: 10),
                      Center(
                        child: OutlinedButton.icon(
                          icon: const Icon(Icons.add),
                          label: const Text('Add Exercise to Group'),
                          onPressed: () async {
                            final Exercise? newExercise =
                                await _showAddExerciseDialog(context);
                            if (newExercise != null) {
                              widget.onAddExerciseToGroup(
                                group.id,
                                newExercise,
                              );
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              );
            } else if (item is RestBlockItem) {
              final restBlock = item;
              return Card(
                key: ValueKey(restBlock.id),
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Rest Block: ${restBlock.durationInSeconds}s',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => widget.onRemoveItem(restBlock.id),
                      ),
                    ],
                  ),
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
        const SizedBox(height: 16.0),
        ElevatedButton.icon(
          icon: const Icon(Icons.add),
          label: const Text('Add New Alternating Group'),
          onPressed: widget.onAddGroup,
        ),
      ],
    );
  }

  Future<Exercise?> _showAddExerciseDialog(BuildContext context) async {
    String? selectedExerciseName;
    final TextEditingController workTimeController = TextEditingController(
      text: '30',
    );
    final TextEditingController restTimeController = TextEditingController();
    final TextEditingController repsController = TextEditingController(); // New controller for reps

    return showDialog<Exercise>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Exercise'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(labelText: 'Exercise Name'),
                  value: selectedExerciseName,
                  items: widget.predefinedExercises.map((String name) {
                    return DropdownMenuItem<String>(
                      value: name,
                      child: Text(name),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    selectedExerciseName = newValue;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select an exercise name';
                    }
                    return null;
                  },
                ),
                TextField(
                  controller: workTimeController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Work Time (seconds)',
                  ),
                ),
                TextField(
                  controller: restTimeController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Rest Time (seconds, Optional)',
                  ),
                ),
                TextField( // New TextField for reps
                  controller: repsController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Reps (Optional)',
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: const Text('Add'),
              onPressed: () {
                final int? workTime = int.tryParse(
                  workTimeController.text.trim(),
                );
                final int? restTime = int.tryParse(
                  restTimeController.text.trim(),
                );
                final int? reps = int.tryParse(repsController.text.trim()); // Parse reps

                if (selectedExerciseName != null &&
                    workTime != null &&
                    workTime > 0) {
                  Navigator.of(context).pop(
                    Exercise(
                      id: const Uuid().v4(),
                      name: selectedExerciseName!,
                      sets: 1,
                      reps: reps, // Pass reps to Exercise constructor
                      workTimeInSeconds: workTime,
                      restTimeInSeconds: restTime,
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please enter valid exercise details.'),
                    ),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future<Exercise?> _showEditExerciseDialog(
    BuildContext context,
    Exercise currentExercise,
  ) async {
    String? selectedExerciseName = currentExercise.name;
    final TextEditingController workTimeController = TextEditingController(
      text: currentExercise.workTimeInSeconds.toString(),
    );
    final TextEditingController restTimeController = TextEditingController(
      text: currentExercise.restTimeInSeconds?.toString() ?? '',
    );
    final TextEditingController repsController = TextEditingController(
      text: currentExercise.reps?.toString() ?? '',
    ); // New controller for reps

    return showDialog<Exercise>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit ${currentExercise.name}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Exercise Name'),
                value: selectedExerciseName,
                items: widget.predefinedExercises.map((String name) {
                  return DropdownMenuItem<String>(
                    value: name,
                    child: Text(name),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  selectedExerciseName = newValue;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select an exercise name';
                  }
                  return null;
                },
              ),
              TextField(
                controller: workTimeController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Work Time (seconds)',
                ),
              ),
              TextField(
                controller: restTimeController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Rest Time (seconds, Optional)',
                ),
              ),
              TextField( // New TextField for reps
                controller: repsController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Reps (Optional)',
                ),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: const Text('Save'),
              onPressed: () {
                final int? newWorkTime = int.tryParse(
                  workTimeController.text.trim(),
                );
                final String restText = restTimeController.text.trim();
                final int? newRestTime = restText.isEmpty
                    ? null
                    : int.tryParse(restText);
                final int? newReps = int.tryParse(repsController.text.trim()); // Parse reps

                if (selectedExerciseName != null &&
                    newWorkTime != null &&
                    newWorkTime > 0) {
                  if (restText.isNotEmpty && newRestTime == null) {
                    // Handle invalid (non-empty, non-numeric) rest time input
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Please enter a valid rest time or leave it empty.',
                        ),
                      ),
                    );
                    return;
                  }
                  Navigator.of(context).pop(
                    Exercise(
                      id: currentExercise.id,
                      name: selectedExerciseName!,
                      sets: 1,
                      reps: newReps, // Pass newReps to Exercise constructor
                      workTimeInSeconds: newWorkTime,
                      restTimeInSeconds: newRestTime,
                      audioFileName: currentExercise.audioFileName,
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Please enter valid work time and select an exercise name.',
                      ),
                    ),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _showEditGroupNameDialog(
    BuildContext context,
    AlternatingGroupItem group,
  ) async {
    final TextEditingController nameController = TextEditingController(
      text: group.name,
    );

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Group Name'),
          content: TextField(
            controller: nameController,
            decoration: const InputDecoration(labelText: 'Group Name'),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: const Text('Save'),
              onPressed: () {
                final String newName = nameController.text.trim();
                if (newName.isNotEmpty) {
                  widget.onEditGroup(
                    group.id,
                    newName,
                    group.cycles,
                    group.groupRestInSeconds,
                  );
                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Group name cannot be empty.'),
                    ),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _showEditCyclesDialog(
    BuildContext context,
    AlternatingGroupItem group,
  ) async {
    final TextEditingController cyclesController = TextEditingController(
      text: group.cycles.toString(),
    );

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Cycles'),
          content: TextField(
            controller: cyclesController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Cycles'),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: const Text('Save'),
              onPressed: () {
                final int? newCycles = int.tryParse(
                  cyclesController.text.trim(),
                );
                if (newCycles != null && newCycles > 0) {
                  widget.onEditGroup(
                    group.id,
                    group.name,
                    newCycles,
                    group.groupRestInSeconds,
                  );
                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please enter a valid number of cycles.'),
                    ),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _showEditGroupRestDialog(
    BuildContext context,
    AlternatingGroupItem group,
  ) async {
    final TextEditingController groupRestController = TextEditingController(
      text: group.groupRestInSeconds?.toString() ?? '',
    );

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Rest Between Cycles'),
          content: TextField(
            controller: groupRestController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Rest between cycles (seconds, Optional)',
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: const Text('Save'),
              onPressed: () {
                final String restText = groupRestController.text.trim();
                if (restText.isEmpty) {
                  widget.onEditGroup(group.id, group.name, group.cycles, null);
                  Navigator.of(context).pop();
                  return;
                }
                final int? newGroupRest = int.tryParse(restText);
                if (newGroupRest != null && newGroupRest >= 0) {
                  widget.onEditGroup(
                    group.id,
                    group.name,
                    group.cycles,
                    newGroupRest,
                  );
                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Please enter a valid rest time (0 or greater).',
                      ),
                    ),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }
}
