import 'package:flutter/material.dart';
import 'dart:developer' as developer;
import 'package:uuid/uuid.dart';
import 'package:provider/provider.dart';
import 'package:workout_timer_app/models/exercise.dart';
import 'package:workout_timer_app/models/user_workout.dart';
import 'package:workout_timer_app/repositories/user_workout_repository.dart';
import 'package:workout_timer_app/widgets/workout_name_text_field.dart';
import 'package:workout_timer_app/widgets/exercise_list.dart';
import 'package:workout_timer_app/widgets/workout_duration_display.dart';
import 'package:workout_timer_app/widgets/save_workout_button.dart';
import 'package:workout_timer_app/models/workout_item.dart';
import 'package:workout_timer_app/models/workout_type.dart';
import 'package:workout_timer_app/widgets/add_exercise_dialog.dart';
import 'package:workout_timer_app/models/alternating_group_item.dart'; // Import new item
import 'package:workout_timer_app/widgets/alternating_group_list.dart'; // Import new widget
import 'package:workout_timer_app/models/rest_block_item.dart'; // Import RestBlockItem

class DefineWorkoutScreen extends StatefulWidget {
  final UserWorkout? workout;

  const DefineWorkoutScreen({super.key, this.workout});

  @override
  State<DefineWorkoutScreen> createState() => _DefineWorkoutScreenState();
}

class _DefineWorkoutScreenState extends State<DefineWorkoutScreen> {
  late UserWorkoutRepository _userWorkoutRepository;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _workoutNameController = TextEditingController();

  List<WorkoutItem> _workoutItems = [];
  String _workoutId = const Uuid().v4();
  WorkoutType _workoutType = WorkoutType.sequential;

  final List<String> _predefinedExercises = [
    'Pull-ups',
    'Dips',
    'Squats',
    'One-legged Squats',
    'Push-ups',
    'Sit-ups',
    'Lunges',
    'Crunches',
    'Bench Press',
    'Deadlift',
    'Muscle-Ups',
    'Handstand Push-Ups',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.workout != null) {
      _workoutId = widget.workout!.id;
      _workoutNameController.text = widget.workout!.name;
      _workoutItems = List.from(widget.workout!.items);
      _workoutType = widget.workout!.workoutType;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _userWorkoutRepository = Provider.of<UserWorkoutRepository>(context);
  }

  @override
  void dispose() {
    _workoutNameController.dispose();
    super.dispose();
  }

  void _addExercise() async {
    final Exercise? newExercise = await showDialog<Exercise>(
      context: context,
      builder: (BuildContext context) {
        return AddExerciseDialog(predefinedExercises: _predefinedExercises);
      },
    );

    if (newExercise != null) {
      setState(() {
        if (_workoutType == WorkoutType.sequential) {
          _workoutItems.add(
            ExerciseItem(id: const Uuid().v4(), exercise: newExercise),
          );
        } else {
          AlternatingGroupItem? lastGroup;
          if (_workoutItems.isNotEmpty &&
              _workoutItems.last is AlternatingGroupItem) {
            lastGroup = _workoutItems.last as AlternatingGroupItem;
          }

          if (lastGroup != null) {
            lastGroup.exercises.add(newExercise);
          } else {
            _workoutItems.add(
              AlternatingGroupItem(
                id: const Uuid().v4(),
                name:
                    'Alternating Group ${_workoutItems.whereType<AlternatingGroupItem>().length + 1}',
                cycles: 1, // Default to 1 cycle
                exercises: [newExercise],
              ),
            );
          }
        }
      });
    }
  }

  void _addRestBlock() {
    final TextEditingController restBlockDurationController =
        TextEditingController(text: '30');

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Rest Block'),
          content: TextField(
            controller: restBlockDurationController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Rest Duration (seconds)',
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
                final int? duration = int.tryParse(
                  restBlockDurationController.text.trim(),
                );
                if (duration != null && duration > 0) {
                  setState(() {
                    _workoutItems.add(
                      RestBlockItem(
                        id: const Uuid().v4(),
                        durationInSeconds: duration,
                      ),
                    );
                  });
                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please enter a valid rest duration.'),
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

  void _addAlternatingGroup() {
    setState(() {
      _workoutItems.add(
        AlternatingGroupItem(
          id: const Uuid().v4(),
          name:
              'Alternating Group ${_workoutItems.whereType<AlternatingGroupItem>().length + 1}',
          cycles: 1, // Default to 1 cycle
          exercises: [],
        ),
      );
    });
  }

  void _removeWorkoutItem(int index) {
    setState(() {
      _workoutItems.removeAt(index);
    });
  }

  void _editWorkoutItem(int index) {
    final WorkoutItem itemToEdit = _workoutItems[index];

    if (itemToEdit is ExerciseItem) {
      final Exercise exerciseToEdit = itemToEdit.exercise;
      final TextEditingController setsController = TextEditingController(
        text: exerciseToEdit.sets.toString(),
      );
      final TextEditingController repsController = TextEditingController(
        text: exerciseToEdit.reps?.toString() ?? '',
      );
      final TextEditingController workTimeController = TextEditingController(
        text: exerciseToEdit.workTimeInSeconds.toString(),
      );
      final TextEditingController restTimeController = TextEditingController(
        text: exerciseToEdit.restTimeInSeconds?.toString() ?? '',
      );
      String selectedExerciseName = exerciseToEdit.name;

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Edit ${exerciseToEdit.name}'),
            content: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DropdownButtonFormField<String>(
                      value: selectedExerciseName,
                      items: _predefinedExercises.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          setState(() {
                            selectedExerciseName = newValue;
                          });
                        }
                      },
                      decoration:
                          const InputDecoration(labelText: 'Exercise Name'),
                    ),
                    TextField(
                      controller: setsController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Sets'),
                    ),
                TextField(
                  controller: repsController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Reps (Optional)',
                  ),
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
              ],
            );
          },
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
                  final int? newSets = int.tryParse(setsController.text.trim());
                  final int? newReps = int.tryParse(repsController.text.trim());
                  final int? newWorkTime = int.tryParse(
                    workTimeController.text.trim(),
                  );
                  final int? newRestTime = int.tryParse(
                    restTimeController.text.trim(),
                  );

                  if (newSets != null &&
                      newSets > 0 &&
                      newWorkTime != null &&
                      newWorkTime > 0) {
                    setState(() {
                      _workoutItems[index] = ExerciseItem(
                        id: exerciseToEdit.id, // Pass existing ID
                        exercise: Exercise(
                          id: exerciseToEdit.id, // Pass existing ID
                          name: selectedExerciseName,
                          sets: newSets,
                          reps: newReps,
                          workTimeInSeconds: newWorkTime,
                          restTimeInSeconds: newRestTime,
                          audioFileName: exerciseToEdit.audioFileName,
                        ),
                      );
                    });
                    Navigator.of(context).pop();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please enter valid sets and work time.'),
                      ),
                    );
                  }
                },
              ),
            ],
          );
        },
      );
    } else if (itemToEdit is RestBlockItem) {
      final TextEditingController restBlockDurationController =
          TextEditingController(text: itemToEdit.durationInSeconds.toString());

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Edit Rest Block'),
            content: TextField(
              controller: restBlockDurationController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Rest Duration (seconds)',
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
                  final int? newDuration = int.tryParse(
                    restBlockDurationController.text.trim(),
                  );
                  if (newDuration != null && newDuration > 0) {
                    setState(() {
                      _workoutItems[index] = RestBlockItem(
                        id: itemToEdit.id, // Keep existing ID
                        durationInSeconds: newDuration,
                      );
                    });
                    Navigator.of(context).pop();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please enter a valid rest duration.'),
                      ),
                    );
                  }
                },
              ),
            ],
          );
        },
      );
    } else if (itemToEdit is AlternatingGroupItem) {
      // No direct edit for AlternatingGroupItem itself, its content is edited via AlternatingGroupList
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Edit exercises within the alternating group directly.',
          ),
        ),
      );
    }
  }

  // Helper to get the actual index of an AlternatingGroupItem in _workoutItems
  int _getActualGroupIndex(String groupId) {
    return _workoutItems.indexWhere(
      (item) => item is AlternatingGroupItem && item.id == groupId,
    );
  }

  void _onReorderItems(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) {
        newIndex -= 1;
      }
      final WorkoutItem item = _workoutItems.removeAt(oldIndex);
      _workoutItems.insert(newIndex, item);
    });
  }

  void _onReorderExercisesInGroup(
    String groupId,
    int oldExerciseIndex,
    int newExerciseIndex,
  ) {
    setState(() {
      final int actualGroupIndex = _getActualGroupIndex(groupId);
      if (actualGroupIndex == -1 || actualGroupIndex >= _workoutItems.length) {
        return; // Invalid group index
      }

      final WorkoutItem currentItem = _workoutItems[actualGroupIndex];
      if (currentItem is! AlternatingGroupItem) {
        return; // Not an alternating group, should not happen based on UI logic
      }

      final AlternatingGroupItem group = currentItem;

      // If there's only one exercise in the group, reordering it doesn't make sense
      // and can lead to crashes with ReorderableListView.
      // We prevent the operation if the list has only one element.
      if (group.exercises.length <= 1) {
        return;
      }

      if (newExerciseIndex > oldExerciseIndex) {
        newExerciseIndex -= 1;
      }

      // Ensure indices are within bounds before attempting to remove/insert
      if (oldExerciseIndex < 0 ||
          oldExerciseIndex >= group.exercises.length ||
          newExerciseIndex < 0 ||
          newExerciseIndex > group.exercises.length) {
        return; // Invalid exercise index
      }

      final Exercise exercise = group.exercises.removeAt(oldExerciseIndex);
      group.exercises.insert(newExerciseIndex, exercise);
    });
  }

  void _onAddExerciseToGroup(String groupId, Exercise newExercise) {
    setState(() {
      final int actualGroupIndex = _getActualGroupIndex(groupId);
      if (actualGroupIndex != -1) {
        final AlternatingGroupItem group =
            _workoutItems[actualGroupIndex] as AlternatingGroupItem;
        group.exercises.add(newExercise);
      }
    });
  }

  void _onRemoveExerciseFromGroup(String groupId, int exerciseIndex) {
    setState(() {
      final int actualGroupIndex = _getActualGroupIndex(groupId);
      if (actualGroupIndex != -1) {
        final AlternatingGroupItem group =
            _workoutItems[actualGroupIndex] as AlternatingGroupItem;
        group.exercises.removeAt(exerciseIndex);
        if (group.exercises.isEmpty) {
          _workoutItems.removeAt(
            actualGroupIndex,
          ); // Remove group if it becomes empty
        }
      }
    });
  }

  void _onEditExerciseInGroup(
    String groupId,
    int exerciseIndex,
    Exercise updatedExercise,
  ) {
    setState(() {
      final int actualGroupIndex = _getActualGroupIndex(groupId);
      if (actualGroupIndex != -1) {
        final AlternatingGroupItem group =
            _workoutItems[actualGroupIndex] as AlternatingGroupItem;
        group.exercises[exerciseIndex] = updatedExercise;
      }
    });
  }

  void _onRemoveItem(String id) {
    setState(() {
      _workoutItems.removeWhere((item) => item.id == id);
    });
  }

  void _onEditGroup(
    String id,
    String newName,
    int newCycles,
    int? newGroupRest,
  ) {
    setState(() {
      final int index = _workoutItems.indexWhere((item) => item.id == id);
      if (index != -1 && _workoutItems[index] is AlternatingGroupItem) {
        final group = _workoutItems[index] as AlternatingGroupItem;
        group.name = newName;
        group.cycles = newCycles;
        group.groupRestInSeconds = newGroupRest;
      }
    });
  }

  int _calculateTotalDuration() {
    int totalDuration = 0;
    for (var item in _workoutItems) {
      if (item is ExerciseItem) {
        totalDuration += item.exercise.sets * item.exercise.workTimeInSeconds;
        if (item.exercise.restTimeInSeconds != null && item.exercise.sets > 1) {
          totalDuration +=
              (item.exercise.sets - 1) * item.exercise.restTimeInSeconds!;
        }
      } else if (item is RestBlockItem) {
        totalDuration += item.durationInSeconds;
      } else if (item is AlternatingGroupItem) {
        int singleCycleDuration = 0;
        for (int i = 0; i < item.exercises.length; i++) {
          final exercise = item.exercises[i];
          singleCycleDuration += exercise.workTimeInSeconds;
          // Add rest time for each exercise that has it defined
          if (exercise.restTimeInSeconds != null) {
            singleCycleDuration += exercise.restTimeInSeconds!;
          }
        }

        totalDuration += singleCycleDuration * item.cycles;

        // Add group rest for each cycle except the last one
        if (item.groupRestInSeconds != null && item.cycles > 1) {
          totalDuration += item.groupRestInSeconds! * (item.cycles - 1);
        }
      }
    }
    return totalDuration;
  }

  String _formatDuration(int totalSeconds) {
    if (totalSeconds < 0) {
      return 'N/A';
    }

    int hours = totalSeconds ~/ 3600;
    int minutes = (totalSeconds % 3600) ~/ 60;
    int seconds = totalSeconds % 60;

    List<String> parts = [];
    if (hours > 0) {
      parts.add('${hours}h');
    }
    if (minutes > 0 || hours > 0) {
      parts.add('${minutes}m');
    }
    if (seconds > 0 || (hours == 0 && minutes == 0)) {
      parts.add('${seconds}s');
    }

    return parts.join(' ');
  }

  Future<void> _saveWorkout() async {
    developer.log('[_saveWorkout] Attempting to save workout.', name: 'DefineWorkoutScreen');

    if (_workoutNameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a workout name.')),
      );
      developer.log('[_saveWorkout] Workout name is empty.', name: 'DefineWorkoutScreen');
      return;
    }

    if (_formKey.currentState!.validate()) {
      if (_workoutItems.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please add at least one exercise or rest block.'),
          ),
        );
        developer.log('[_saveWorkout] Workout items list is empty.', name: 'DefineWorkoutScreen');
        return;
      }

      // Remove empty alternating groups before saving
      final int initialItemCount = _workoutItems.length;
      _workoutItems.removeWhere(
        (item) => item is AlternatingGroupItem && item.exercises.isEmpty,
      );
      if (_workoutItems.length < initialItemCount) {
        developer.log('[_saveWorkout] Removed empty alternating groups. New item count: ${_workoutItems.length}', name: 'DefineWorkoutScreen');
      }

      if (_workoutItems.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Workout cannot be empty after removing empty groups.',
            ),
          ),
        );
        developer.log('[_saveWorkout] Workout items list became empty after removing empty groups.', name: 'DefineWorkoutScreen');
        return;
      }

      final String workoutName = _workoutNameController.text.trim();
      final int totalDuration = _calculateTotalDuration();

      final UserWorkout newWorkout = UserWorkout(
        id: _workoutId,
        name: workoutName,
        items: _workoutItems,
        totalWorkoutTime: totalDuration,
        workoutType: _workoutType,
      );

      developer.log('[_saveWorkout] UserWorkout object created: id=$_workoutId, name=$workoutName, totalDuration=$totalDuration, workoutType=${_workoutType.name}, itemsCount=${_workoutItems.length}', name: 'DefineWorkoutScreen');

      try {
        developer.log('[_saveWorkout] Calling saveUserWorkout on repository...', name: 'DefineWorkoutScreen');
        await _userWorkoutRepository.saveUserWorkout(newWorkout);
        developer.log('[_saveWorkout] saveUserWorkout completed successfully.', name: 'DefineWorkoutScreen');
      } catch (e, stack) {
        developer.log('[_saveWorkout] Error saving workout: $e\n$stack', name: 'DefineWorkoutScreen', error: e, stackTrace: stack);
        if (!mounted) {
          developer.log('[_saveWorkout] Widget is not mounted after error. Cannot show SnackBar.', name: 'DefineWorkoutScreen');
          return;
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving workout: $e')),
        );
        return;
      }

      if (!mounted) {
        developer.log('[_saveWorkout] Widget is not mounted after successful save. Cannot pop navigator.', name: 'DefineWorkoutScreen');
        return;
      }
      developer.log('[_saveWorkout] Navigating back after successful save.', name: 'DefineWorkoutScreen');
      Navigator.of(context).pop();
    } else {
      developer.log('[_saveWorkout] Form validation failed.', name: 'DefineWorkoutScreen');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.workout == null ? 'Define New Workout' : 'Edit Workout',
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              WorkoutNameTextField(controller: _workoutNameController),
              const SizedBox(height: 20),
              SegmentedButton<WorkoutType>(
                segments: <ButtonSegment<WorkoutType>>[
                  ButtonSegment<WorkoutType>(
                    value: WorkoutType.sequential,
                    label: const Text('Sequential'),
                    icon: Opacity(
                      opacity: _workoutType == WorkoutType.sequential
                          ? 1.0
                          : 0.0,
                      child: const Icon(Icons.check),
                    ),
                  ),
                  ButtonSegment<WorkoutType>(
                    value: WorkoutType.alternating,
                    label: const Text('Alternating'),
                    icon: Opacity(
                      opacity: _workoutType == WorkoutType.alternating
                          ? 1.0
                          : 0.0,
                      child: const Icon(Icons.check),
                    ),
                  ),
                ],
                selected: <WorkoutType>{_workoutType},
                onSelectionChanged: (Set<WorkoutType> newSelection) {
                  setState(() {
                    _workoutType = newSelection.first;
                    // Clear workout items if switching type to avoid invalid combinations
                    _workoutItems.clear();
                  });
                },
              ),
              const SizedBox(height: 20),
              if (_workoutType == WorkoutType.sequential) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      onPressed: _addExercise,
                      icon: const Icon(Icons.add),
                      label: const Text('Add Exercise'),
                    ),
                    ElevatedButton.icon(
                      onPressed: _addRestBlock,
                      icon: const Icon(Icons.add),
                      label: const Text('Add Rest Block'),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                ExerciseList(
                  workoutItems: _workoutItems,
                  onEditWorkoutItem: _editWorkoutItem,
                  onRemoveWorkoutItem: _removeWorkoutItem,
                  onReorderWorkoutItems: (oldIndex, newIndex) {
                    setState(() {
                      if (newIndex > oldIndex) {
                        newIndex -= 1;
                      }
                      final WorkoutItem item = _workoutItems.removeAt(oldIndex);
                      _workoutItems.insert(newIndex, item);
                    });
                  },
                ),
              ] else if (_workoutType == WorkoutType.alternating) ...[
                AlternatingGroupList(
                  workoutItems: _workoutItems,
                  onReorderItems: _onReorderItems,
                  onReorderExercisesInGroup: _onReorderExercisesInGroup,
                  onAddExerciseToGroup: _onAddExerciseToGroup,
                  onRemoveExerciseFromGroup: _onRemoveExerciseFromGroup,
                  onEditExerciseInGroup: _onEditExerciseInGroup,
                  onRemoveItem: _onRemoveItem, // Use onRemoveItem
                  onAddGroup: _addAlternatingGroup,
                  predefinedExercises: _predefinedExercises,
                  onEditGroup: _onEditGroup, // Use onEditGroup
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed:
                      _addRestBlock, // Rest blocks can still be added between groups
                  icon: const Icon(Icons.add),
                  label: const Text('Add Rest Block (between groups)'),
                ),
              ],
              const SizedBox(height: 20),
              WorkoutDurationDisplay(
                totalDurationInSeconds: _calculateTotalDuration(),
                formatDuration: _formatDuration,
              ),
              const SizedBox(height: 20),
              SaveWorkoutButton(onPressed: _saveWorkout),
            ],
          ),
        ),
      ),
    );
  }
}
