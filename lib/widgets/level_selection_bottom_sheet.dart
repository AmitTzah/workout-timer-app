import 'package:flutter/material.dart';
import 'package:workout_timer_app/models/user_workout.dart';
import 'package:workout_timer_app/models/workout_item.dart';
import 'package:workout_timer_app/models/alternating_group_item.dart';
import 'package:workout_timer_app/models/workout_type.dart';

class LevelSelectionBottomSheet {
  static Future<dynamic> show(BuildContext context, dynamic currentLevel, UserWorkout workout) async {
    bool isAlternating = workout.workoutType == WorkoutType.alternating;
    String unit = isAlternating ? 'Cycles' : 'Sets';

    // Helper to calculate total units (sets or cycles) for a given level
    int calculateTotalUnitsForLevel(int level) {
      int totalOriginalUnits = workout.items.fold(0, (sum, item) {
        if (isAlternating) {
          if (item is AlternatingGroupItem) {
            return sum + item.cycles;
          }
        } else {
          if (item is ExerciseItem) {
            return sum + item.exercise.sets;
          }
        }
        return sum;
      });

      if (totalOriginalUnits == 0) return 0;

      double multiplier = 1.0 + ((level - 1) * 20) / 100.0;
      if (level == 1) multiplier = 1.0;

      int calculatedUnits = (totalOriginalUnits * multiplier).ceil();

      if (level > 1) {
        int previousLevelUnits = calculateTotalUnitsForLevel(level - 1);
        if (calculatedUnits <= previousLevelUnits) {
          calculatedUnits = previousLevelUnits + 1;
        }
      }
      return calculatedUnits;
    }

    return showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Select Workout Level',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    for (int i = 1; i <= 10; i++)
                      ListTile(
                        title: Text(
                          'Level $i (+${i == 1 ? 0 : ((i - 1) * 20)}%) - Total $unit: ${calculateTotalUnitsForLevel(i)}',
                        ),
                        trailing: i == currentLevel ? const Icon(Icons.check, color: Colors.blue) : null,
                        onTap: () {
                          Navigator.pop(context, i);
                        },
                      ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
