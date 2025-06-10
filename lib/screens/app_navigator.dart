import 'package:flutter/material.dart';
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

  static const List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
    WorkoutCalendarScreen(),
    WorkoutSummariesScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
