import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// Import Hive
import 'package:hive_flutter/hive_flutter.dart';
import 'package:workout_timer_app/screens/app_navigator.dart';
import 'package:workout_timer_app/repositories/user_workout_repository.dart';
import 'package:workout_timer_app/repositories/workout_summary_repository.dart';
import 'package:workout_timer_app/repositories/hive/hive_user_workout_repository_impl.dart';
import 'package:workout_timer_app/repositories/hive/hive_workout_summary_repository_impl.dart';
import 'package:workout_timer_app/services/audio_service.dart';
import 'package:workout_timer_app/models/user_workout.dart'; // Import UserWorkout
import 'package:workout_timer_app/models/workout_summary.dart'; // Import WorkoutSummary
import 'package:workout_timer_app/models/exercise.dart';
import 'package:workout_timer_app/models/goal.dart';
import 'package:workout_timer_app/models/workout_set.dart';
import 'package:workout_timer_app/models/workout_item.dart';
import 'package:workout_timer_app/models/workout_type.dart';
import 'package:workout_timer_app/models/alternating_group_item.dart';
import 'package:workout_timer_app/models/rest_block_item.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  if (!Hive.isAdapterRegistered(0)) Hive.registerAdapter(ExerciseAdapter());
  if (!Hive.isAdapterRegistered(1)) Hive.registerAdapter(WorkoutSummaryAdapter());
  if (!Hive.isAdapterRegistered(2)) Hive.registerAdapter(UserWorkoutAdapter());
  if (!Hive.isAdapterRegistered(3)) Hive.registerAdapter(ExerciseItemAdapter());
  if (!Hive.isAdapterRegistered(9)) Hive.registerAdapter(RestBlockItemAdapter());
  if (!Hive.isAdapterRegistered(5)) Hive.registerAdapter(GoalAdapter());
  if (!Hive.isAdapterRegistered(6)) Hive.registerAdapter(WorkoutSetAdapter());
  if (!Hive.isAdapterRegistered(7)) Hive.registerAdapter(WorkoutTypeAdapter());
  if (!Hive.isAdapterRegistered(8)) Hive.registerAdapter(AlternatingGroupItemAdapter());

  // Open Hive boxes
  await Hive.openBox<UserWorkout>('user_workouts');
  await Hive.openBox<WorkoutSummary>('workout_summaries');

  runApp(
    MultiProvider(
      providers: [
        Provider<UserWorkoutRepository>(
          create: (_) => HiveUserWorkoutRepositoryImpl(
            Hive.box<UserWorkout>('user_workouts'),
          ),
        ),
        Provider<WorkoutSummaryRepository>(
          create: (_) => HiveWorkoutSummaryRepositoryImpl(
            Hive.box<WorkoutSummary>('workout_summaries'),
          ),
        ),
        Provider<AudioService>(
          create: (_) => AudioService(),
          dispose: (_, audioService) => audioService.dispose(),
        ),
      ],
      child: const WorkoutTimerApp(),
    ),
  );
}

class WorkoutTimerApp extends StatelessWidget {
  const WorkoutTimerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Workout Timer',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white, // Ensures a clean, white AppBar
          foregroundColor: Colors.black87, // For icons like back arrow, menu, etc.
          elevation: 1.0, // Subtle shadow for separation
          centerTitle: true, // Centers the title text
          titleTextStyle: TextStyle(
            color: Colors.black87, // Dark grey for the title text
            fontSize: 21.0,
            fontWeight: FontWeight.w600, // Semi-bold
          ),
        ),
      ),
      home: const AppNavigator(),
    );
  }
}
