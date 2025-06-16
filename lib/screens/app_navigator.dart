import 'package:flutter/material.dart';
import 'package:workout_timer_app/models/workout_summary.dart';
import 'package:workout_timer_app/screens/home_screen.dart';
import 'package:workout_timer_app/screens/workout_calendar_screen.dart';
import 'package:workout_timer_app/screens/workout_summaries_screen.dart';

class AppNavigator extends StatefulWidget {
  const AppNavigator({super.key});

  @override
  State<AppNavigator> createState() => _AppNavigatorState();
}

class _AppNavigatorState extends State<AppNavigator> {
  int _selectedIndex = 0;
  WorkoutSummary? _highlightedSummary;
  bool _isNavigatedFromCalendar = false;

  late final List<Widget> _widgetOptions;

  static const List<String> _appBarTitles = <String>[
    'Workouts',
    'Calendar',
    'Workout Summaries',
  ];

  @override
  void initState() {
    super.initState();
    _widgetOptions = <Widget>[
      const HomeScreen(),
      WorkoutCalendarScreen(onNavigateToHistory: _navigateToHistoryWithHighlight),
      WorkoutSummariesScreen(highlightedSummary: _highlightedSummary),
    ];
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
      _widgetOptions[2] = WorkoutSummariesScreen(highlightedSummary: _highlightedSummary);
    });
  }

  @override
  Widget build(BuildContext context) {
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
      ),
      body: Center(child: _widgetOptions.elementAt(_selectedIndex)),
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
