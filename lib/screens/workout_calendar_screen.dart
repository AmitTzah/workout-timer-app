import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:provider/provider.dart';
import 'package:workout_timer_app/widgets/workout_calendar.dart';
import 'package:workout_timer_app/widgets/workout_event_list.dart';

import '../models/workout_summary.dart';
import '../repositories/workout_summary_repository.dart';

class WorkoutCalendarScreen extends StatefulWidget {
  final Function(WorkoutSummary)? onNavigateToHistory;
  const WorkoutCalendarScreen({super.key, this.onNavigateToHistory});

  @override
  WorkoutCalendarScreenState createState() => WorkoutCalendarScreenState();
}

class WorkoutCalendarScreenState extends State<WorkoutCalendarScreen> {
  late final WorkoutSummaryRepository _repository;
  List<WorkoutSummary> _summaries = [];
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  late Map<DateTime, List<WorkoutSummary>> _events;
  CalendarFormat _calendarFormat = CalendarFormat.month;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _events = {};
    // _initRepository(); // Removed as repository is now provided via Provider
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _repository = Provider.of<WorkoutSummaryRepository>(context, listen: false);
  }

  List<WorkoutSummary> _getEventsForDay(DateTime day) {
    return _events[DateTime(day.year, day.month, day.day)] ?? [];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
      });
    }
  }

  void _onPageChanged(DateTime focusedDay) {
    setState(() {
      _focusedDay = focusedDay;
    });
  }

  void _onFormatChanged(CalendarFormat format) {
    if (_calendarFormat != format) {
      setState(() {
        _calendarFormat = format;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<List<WorkoutSummary>>(
        stream: _repository.watchAllWorkoutSummaries(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No workouts found.'));
          } else {
            _summaries = snapshot.data!;
            _events = _groupWorkoutsByDay(_summaries);
            return Column(
              children: [
                WorkoutCalendar(
                  focusedDay: _focusedDay,
                  selectedDay: _selectedDay,
                  calendarFormat: _calendarFormat,
                  events: _events,
                  onDaySelected: _onDaySelected,
                  onFormatChanged: _onFormatChanged,
                  onPageChanged: _onPageChanged,
                  getEventsForDay: _getEventsForDay,
                ),
                const SizedBox(height: 8.0),
                Expanded(
                  child: WorkoutEventList(
                    events: _getEventsForDay(_selectedDay!),
                    onNavigateToHistory: widget.onNavigateToHistory,
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }

  Map<DateTime, List<WorkoutSummary>> _groupWorkoutsByDay(
      List<WorkoutSummary> summaries) {
    Map<DateTime, List<WorkoutSummary>> data = {};
    for (var summary in summaries) {
      DateTime date =
          DateTime(summary.date.year, summary.date.month, summary.date.day);
      if (data[date] == null) {
        data[date] = [];
      }
      data[date]!.add(summary);
    }
    return data;
  }
}
