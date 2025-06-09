import 'package:exercise_timer_app/models/user_workout.dart';
import 'package:exercise_timer_app/models/exercise.dart'; // Still needed for Exercise object within WorkoutSet
import 'package:exercise_timer_app/models/workout_set.dart';
import 'package:uuid/uuid.dart'; // Import Uuid
import 'package:exercise_timer_app/models/workout_item.dart'; // New: Import WorkoutItem
import 'package:exercise_timer_app/models/alternating_group_item.dart'; // Import AlternatingGroupItem
import 'package:exercise_timer_app/models/rest_block_item.dart'; // Import RestBlockItem

/// Manages the core logic of workout structure and progression.
/// This service is independent of UI or specific timer implementations.
import 'package:exercise_timer_app/models/workout_type.dart';

class WorkoutLogicService {
  final UserWorkout _baseWorkout;
  final WorkoutType _workoutType;
  final dynamic _selectedLevelOrMode; // int for level, String for "survival"

  late List<WorkoutSet> _exercisesToPerform;
  int _currentOverallSetIndex = 0;
  int _totalSetsCompleted = 0;
  int _totalSetsInPlan = 0; // Renamed for clarity (includes rests)
  int _totalWorkSets = 0; // New: Only counts actual exercise sets

  // Public getters for previously private members
  dynamic get selectedLevelOrMode => _selectedLevelOrMode;
  WorkoutType get workoutType => _workoutType;

  WorkoutLogicService({
    required UserWorkout baseWorkout,
    required WorkoutType workoutType,
    required dynamic selectedLevelOrMode,
  }) : _baseWorkout = baseWorkout,
       _workoutType = workoutType,
       _selectedLevelOrMode = selectedLevelOrMode {
    _initializeWorkoutPlan();
  }

  // Public Getters
  List<WorkoutSet> get exercisesToPerform => _exercisesToPerform;
  int get currentOverallSetIndex => _currentOverallSetIndex;
  int get totalSetsCompleted => _totalSetsCompleted;
  bool get isSurvivalMode => _selectedLevelOrMode == "survival";

  WorkoutSet? get currentWorkoutSet =>
      _exercisesToPerform.isNotEmpty &&
          _currentOverallSetIndex < _exercisesToPerform.length
      ? _exercisesToPerform[_currentOverallSetIndex]
      : null;

  int get totalSetsInPlan => _totalSetsInPlan; // Use new name
  int get totalWorkSets => _totalWorkSets; // New getter

  /// Calculates the total expected duration of the workout including rest periods.
  int get totalWorkoutDurationWithRests {
    int totalDuration = 0;
    for (final set in _exercisesToPerform) {
      if (set.isRestSet) {
        totalDuration +=
            set.restBlockDuration ?? (set.exercise.restTimeInSeconds ?? 0);
      } else {
        totalDuration += set.exercise.workTimeInSeconds;
      }
    }
    return totalDuration;
  }

  /// Initializes the workout plan based on level/mode and alternation.
  void _initializeWorkoutPlan() {
    List<WorkoutSet> workoutPlan = [];

    if (_workoutType == WorkoutType.sequential) {
      // Sequential Mode
      for (var item in _baseWorkout.items) {
        if (item is ExerciseItem) {
          final adjustedExercise = _applyLevelModifier([
            item,
          ]).first; // Apply level modifier to single exercise
          for (int s = 1; s <= adjustedExercise.sets; s++) {
            workoutPlan.add(
              WorkoutSet(
                exercise: adjustedExercise,
                setNumber: s,
                isRestSet: false,
                isRestBlock: false,
              ),
            );
            // Add per-set rest if defined and not the last set
            if (adjustedExercise.restTimeInSeconds != null &&
                adjustedExercise.restTimeInSeconds! > 0 &&
                s < adjustedExercise.sets) {
              workoutPlan.add(
                WorkoutSet(
                  exercise: adjustedExercise,
                  setNumber: s,
                  isRestSet: true,
                  isRestBlock: false,
                  restBlockDuration: adjustedExercise.restTimeInSeconds,
                ),
              );
            }
          }
        } else if (item is RestBlockItem) {
          workoutPlan.add(
            WorkoutSet(
              exercise: Exercise(
                id: item.id,
                name: 'Rest Block',
                sets: 1,
                workTimeInSeconds: item.durationInSeconds,
              ),
              setNumber: 1,
              isRestSet: true,
              isRestBlock: true,
              restBlockDuration: item.durationInSeconds,
            ),
          );
        }
      }
    } else {
      // Alternating Mode (handles AlternatingGroupItem and RestBlockItem)
      for (var item in _baseWorkout.items) {
        if (item is AlternatingGroupItem) {
          int adjustedCycles = _calculateAdjustedCyclesForLevel(item.cycles);
          List<Exercise> exercisesInGroup = item.exercises;

          for (int cycle = 0; cycle < adjustedCycles; cycle++) {
            for (var exercise in exercisesInGroup) {
              // Add work set
              workoutPlan.add(
                WorkoutSet(
                  exercise: exercise,
                  setNumber: cycle + 1, // Cycle number as set number
                  isRestSet: false,
                  isRestBlock: false,
                ),
              );
              // Add per-exercise rest if defined
              if (exercise.restTimeInSeconds != null &&
                  exercise.restTimeInSeconds! > 0) {
                workoutPlan.add(
                  WorkoutSet(
                    exercise: exercise,
                    setNumber: cycle + 1,
                    isRestSet: true,
                    isRestBlock: false,
                    restBlockDuration: exercise.restTimeInSeconds,
                  ),
                );
              }
            }
            // Add group rest after each cycle, except the last one
            if (item.groupRestInSeconds != null &&
                item.groupRestInSeconds! > 0 &&
                cycle < adjustedCycles - 1) {
              workoutPlan.add(
                WorkoutSet(
                  exercise: Exercise(
                    id: const Uuid().v4(),
                    name: 'Group Rest',
                    sets: 1,
                    workTimeInSeconds: item.groupRestInSeconds!,
                  ),
                  setNumber: cycle + 1,
                  isRestSet: true,
                  isRestBlock: true,
                  restBlockDuration: item.groupRestInSeconds,
                ),
              );
            }
          }
        } else if (item is RestBlockItem) {
          // Rest blocks are added directly at their position in the main plan
          workoutPlan.add(
            WorkoutSet(
              exercise: Exercise(
                id: item.id,
                name: 'Rest Block',
                sets: 1,
                workTimeInSeconds: item.durationInSeconds,
              ),
              setNumber: 1,
              isRestSet: true,
              isRestBlock: true,
              restBlockDuration: item.durationInSeconds,
            ),
          );
        }
      }
    }

    _exercisesToPerform = workoutPlan;
    _totalSetsInPlan = workoutPlan.length; // Total sets including rests
    _totalWorkSets = workoutPlan.where((set) => !set.isRestSet).length; // Only work sets
  }

  /// Advances to the next set in the workout plan.
  /// Returns true if the workout continues, false if it has naturally completed.
  bool moveToNextSet() {
    // Only increment total sets completed if the set that just finished was not a rest set.
    if (currentWorkoutSet != null && !currentWorkoutSet!.isRestSet) {
      _totalSetsCompleted++;
    }
    bool workoutContinues = true;

    if (_currentOverallSetIndex < _exercisesToPerform.length - 1) {
      _currentOverallSetIndex++;
    } else {
      if (isSurvivalMode) {
        _currentOverallSetIndex = 0; // Loop back for survival mode
      } else {
        workoutContinues = false; // End workout for non-survival modes
      }
    }
    return workoutContinues;
  }

  /// Applies level modifiers to the workout exercises for sequential mode.
  List<Exercise> _applyLevelModifier(List<ExerciseItem> originalExerciseItems) {
    List<Exercise> adjustedExercises = [];
    if (_selectedLevelOrMode is int &&
        _selectedLevelOrMode >= 1 &&
        _selectedLevelOrMode <= 10) {
      final int level = _selectedLevelOrMode;
      int originalTotalSets = originalExerciseItems.fold(
        0,
        (sum, item) => sum + item.exercise.sets,
      );
      if (originalTotalSets == 0) {
        return originalExerciseItems.map((e) => e.exercise).toList();
      }

      int targetTotalSets = _calculateTotalSetsForLevelStatic(
        level,
        originalTotalSets,
      );

      int currentSumOfAdjustedSets = 0;
      List<Exercise> tempAdjustedExercises = [];

      for (var item in originalExerciseItems) {
        final exercise = item.exercise;
        double proportion = exercise.sets / originalTotalSets;
        int adjustedSets = (proportion * targetTotalSets).round();

        if (exercise.sets > 0 && adjustedSets == 0) {
          adjustedSets = 1;
        }
        tempAdjustedExercises.add(
          Exercise(
            id: exercise.id, // Pass existing ID
            name: exercise.name,
            sets: adjustedSets,
            reps: exercise.reps,
            workTimeInSeconds: exercise.workTimeInSeconds,
            restTimeInSeconds: exercise.restTimeInSeconds,
            audioFileName: exercise.audioFileName,
          ),
        );
        currentSumOfAdjustedSets += adjustedSets;
      }

      int difference = targetTotalSets - currentSumOfAdjustedSets;
      if (difference != 0 && tempAdjustedExercises.isNotEmpty) {
        int largestSetIndex = 0;
        for (int i = 1; i < tempAdjustedExercises.length; i++) {
          if (tempAdjustedExercises[i].sets >
              tempAdjustedExercises[largestSetIndex].sets) {
            largestSetIndex = i;
          }
        }

        Exercise exerciseToAdjust = tempAdjustedExercises[largestSetIndex];
        tempAdjustedExercises[largestSetIndex] = Exercise(
          id: exerciseToAdjust.id, // Pass existing ID
          name: exerciseToAdjust.name,
          sets: (exerciseToAdjust.sets + difference)
              .clamp(1, double.infinity)
              .toInt(),
          reps: exerciseToAdjust.reps,
          workTimeInSeconds: exerciseToAdjust.workTimeInSeconds,
          restTimeInSeconds: exerciseToAdjust.restTimeInSeconds,
          audioFileName: exerciseToAdjust.audioFileName,
        );
      }
      adjustedExercises = tempAdjustedExercises;
    } else {
      adjustedExercises = originalExerciseItems.map((e) => e.exercise).toList();
    }
    return adjustedExercises;
  }

  /// Calculates the adjusted number of cycles for an alternating group based on the selected level.
  int _calculateAdjustedCyclesForLevel(int originalCycles) {
    if (_selectedLevelOrMode is int &&
        _selectedLevelOrMode >= 1 &&
        _selectedLevelOrMode <= 10) {
      final int level = _selectedLevelOrMode;
      return _calculateTotalSetsForLevelStatic(level, originalCycles);
    }
    return originalCycles;
  }

  /// Helper to calculate total sets for a given level, ensuring strict increase.
  static int _calculateTotalSetsForLevelStatic(
    int level,
    int originalTotalSets,
  ) {
    if (originalTotalSets == 0) return 0;

    double multiplier;
    if (level == 1) {
      multiplier = 1.0;
    } else {
      multiplier = 1.0 + ((level - 1) * 20) / 100.0;
    }

    int calculatedSets = (originalTotalSets * multiplier).ceil();

    if (level > 1) {
      int previousLevelSets = _calculateTotalSetsForLevelStatic(
        level - 1,
        originalTotalSets,
      );
      if (calculatedSets <= previousLevelSets) {
        calculatedSets = previousLevelSets + 1;
      }
    }
    return calculatedSets;
  }
}
