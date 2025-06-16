import 'package:uuid/uuid.dart';
import '../models/user_workout.dart';
import '../models/alternating_group_item.dart';
import '../models/exercise.dart';
import '../models/workout_type.dart';

final uuid = Uuid();

final List<UserWorkout> defaultWorkouts = [
  UserWorkout(
    id: uuid.v4(),
    name: 'Basic Upper Body',
    totalWorkoutTime: 1800, // 30 minutes in seconds
    workoutType: WorkoutType.alternating,
    items: [
      AlternatingGroupItem(
        id: uuid.v4(),
        name: 'Back, ABS, Chest',
        cycles: 15,
        exercises: [
          Exercise(
            id: uuid.v4(),
            name: 'Pull-ups',
            sets: 1,
            reps: 4,
            workTimeInSeconds: 36,
          ),
          Exercise(
            id: uuid.v4(),
            name: 'Sit-ups',
            sets: 1,
            reps: 10,
            workTimeInSeconds: 48,
          ),
          Exercise(
            id: uuid.v4(),
            name: 'Dips',
            sets: 1,
            reps: 4,
            workTimeInSeconds: 36,
          ),
        ],
      ),
    ],
  ),
];