import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_timer_app/models/workout_summary.dart';
import 'package:workout_timer_app/repositories/user_workout_repository.dart';
import 'package:workout_timer_app/repositories/workout_summary_repository.dart';
import 'package:workout_timer_app/screens/home_screen.dart';
import 'package:workout_timer_app/screens/workout_calendar_screen.dart';
import 'package:workout_timer_app/screens/workout_summaries_screen.dart';
import 'package:workout_timer_app/services/backup_service.dart';

class AppNavigator extends StatefulWidget {
  const AppNavigator({super.key});

  @override
  State<AppNavigator> createState() => _AppNavigatorState();
}

class _AppNavigatorState extends State<AppNavigator> {
  int _selectedIndex = 0;
  WorkoutSummary? _highlightedSummary;
  bool _isNavigatedFromCalendar = false;

  late UserWorkoutRepository _userWorkoutRepository;
  late WorkoutSummaryRepository _workoutSummaryRepository;
  late BackupService _backupService;

  static const List<String> _appBarTitles = <String>[
    'Workouts',
    'Calendar',
    'Workout Summaries',
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _userWorkoutRepository = Provider.of<UserWorkoutRepository>(context);
    _workoutSummaryRepository = Provider.of<WorkoutSummaryRepository>(context);
    _backupService = BackupService(_userWorkoutRepository, _workoutSummaryRepository);
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _highlightedSummary = null; // Clear highlight when changing tabs
      _isNavigatedFromCalendar = false; // Reset when changing tabs
    });
  }

  void _navigateToHistoryWithHighlight(WorkoutSummary summary) {
    setState(() {
      _selectedIndex = 2; // Index for WorkoutSummariesScreen
      _highlightedSummary = summary;
      _isNavigatedFromCalendar = true; // Set flag when navigating from calendar
    });
  }

  @override
  Widget build(BuildContext context) {
    void showSnackBar(String message) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          duration: const Duration(seconds: 2),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(_appBarTitles[_selectedIndex]),
        leading: _isNavigatedFromCalendar
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  setState(() {
                    _selectedIndex = 1; // Navigate back to Calendar screen
                    _highlightedSummary = null;
                    _isNavigatedFromCalendar = false;
                  });
                },
              )
            : null,
        actions: _selectedIndex == 0
            ? [
                IconButton(
                  icon: const Icon(Icons.upload_file),
                  tooltip: 'Import Data',
                  onPressed: () async {
                    final String message = await _backupService.importData();
                    showSnackBar(message);
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.download),
                  tooltip: 'Export Data',
                  onPressed: () async {
                    final String message = await _backupService.exportData();
                    showSnackBar(message);
                  },
                ),
              ]
            : null,
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          const HomeScreen(),
          WorkoutCalendarScreen(onNavigateToHistory: _navigateToHistoryWithHighlight),
          WorkoutSummariesScreen(highlightedSummary: _highlightedSummary),
        ],
      ),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          splashFactory: InkRipple.splashFactory,
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.fitness_center),
              label: 'Workouts',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today),
              label: 'Calendar',
            ),
            BottomNavigationBarItem(icon: Icon(Icons.history), label: 'History'),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Theme.of(context).primaryColor,
          selectedFontSize: 14,
          unselectedFontSize: 12,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
