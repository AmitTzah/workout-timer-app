import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_timer_app/models/user_workout.dart';
import 'package:workout_timer_app/repositories/user_workout_repository.dart';
import 'package:workout_timer_app/screens/define_workout_screen.dart';
import 'package:workout_timer_app/widgets/workout_card/workout_card.dart';
import 'package:workout_timer_app/widgets/level_selection_bottom_sheet.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late UserWorkoutRepository _userWorkoutRepository;

  final Map<String, int> _levelSelections = {}; // Stores int for level
  final Map<String, bool> _survivalModeSelections = {}; // Stores bool for survival mode

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _userWorkoutRepository = Provider.of<UserWorkoutRepository>(context);
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _deleteWorkout(String id) async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content: const Text('Are you sure you want to delete this workout?'),
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

    if (confirm == true) {
      await _userWorkoutRepository.deleteWorkout(id);
    }
  }

  String _formatTime(int totalSeconds, {bool includeHours = false}) {
    final int hours = totalSeconds ~/ 3600;
    final int minutes = (totalSeconds % 3600) ~/ 60;
    final int seconds = totalSeconds % 60;

    String formattedTime = '';
    if (includeHours && hours > 0) {
      formattedTime += '${hours}h ';
    }
    formattedTime += '${minutes}m ${seconds}s';
    return formattedTime.trim();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<List<UserWorkout>>(
        stream: _userWorkoutRepository.watchAllWorkouts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'No workouts defined yet. Tap the + button to create one!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
            );
          } else {
            final userWorkouts = snapshot.data!;
            // Initialize selections from persisted values, or default
            for (var workout in userWorkouts) {
              _levelSelections.putIfAbsent(workout.id, () => workout.selectedLevel ?? 1);
              _survivalModeSelections.putIfAbsent(workout.id, () => workout.selectedSurvivalMode ?? false);
            }
            return ListView.builder(
              itemCount: userWorkouts.length,
              itemBuilder: (context, index) {
                final workout = userWorkouts[index];
                return WorkoutCard(
                  workout: workout,
                  formatTime: _formatTime,
                  showLevelSelectionBottomSheet: LevelSelectionBottomSheet.show,
                  deleteWorkout: _deleteWorkout,
                  levelSelections: _levelSelections,
                  survivalModeSelections: _survivalModeSelections,
                  onSelectionsChanged: () {
                    // This callback is still needed to trigger a rebuild of the card if selections change
                    // but it doesn't need to reload workouts from the repository as the stream handles it.
                    setState(() {});
                  },
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const DefineWorkoutScreen(),
            ),
          ); // No need to refresh explicitly, listener handles it
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
