import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_timer_app/screens/app_navigator.dart';
import 'package:workout_timer_app/repositories/user_workout_repository.dart';
import 'package:workout_timer_app/repositories/workout_summary_repository.dart';
import 'package:workout_timer_app/repositories/sqflite/sqflite_user_workout_repository_impl.dart';
import 'package:workout_timer_app/repositories/sqflite/sqflite_workout_summary_repository_impl.dart';
import 'package:workout_timer_app/services/audio_service.dart';
import 'package:workout_timer_app/services/sqflite_database_service.dart'; // Import SqfliteDatabaseService
// Import UserWorkout
// Import WorkoutSummary

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final sqfliteService = SqfliteDatabaseService(); // Instantiate SqfliteDatabaseService
  await sqfliteService.init(); // Initialize the database

  runApp(
    MultiProvider(
      providers: [
        Provider<UserWorkoutRepository>(
          create: (_) => SqfliteUserWorkoutRepositoryImpl(sqfliteService),
        ),
        Provider<WorkoutSummaryRepository>(
          create: (_) => SqfliteWorkoutSummaryRepositoryImpl(sqfliteService),
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
