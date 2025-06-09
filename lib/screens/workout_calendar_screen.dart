import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:workout_timer_app/services/database_service.dart';

import '../models/workout_summary.dart';
import '../repositories/workout_summary_repository.dart';
import 'workout_summaries_screen.dart';

class WorkoutCalendarScreen extends StatefulWidget {
  const WorkoutCalendarScreen({super.key});

  @override
  WorkoutCalendarScreenState createState() => WorkoutCalendarScreenState();
}

class WorkoutCalendarScreenState extends State<WorkoutCalendarScreen> {
  late final WorkoutSummaryRepository _repository;
  Future<List<WorkoutSummary>>? _summariesFuture;
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
    _initRepository();
  }

  Future<void> _initRepository() async {
    final summariesBox = await DatabaseService.openWorkoutSummariesBox();
    _repository = WorkoutSummaryRepository(summariesBox);
    setState(() {
      _summariesFuture = Future.value(_repository.getAllWorkoutSummaries());
    });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Workout Calendar'),
      ),
      body: _summariesFuture == null
          ? const Center(child: CircularProgressIndicator())
          : FutureBuilder<List<WorkoutSummary>>(
        future: _summariesFuture!,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting && _summaries.isEmpty) {
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
                TableCalendar<WorkoutSummary>(
                  firstDay: DateTime.utc(2020, 1, 1),
                  lastDay: DateTime.utc(2030, 12, 31),
                  focusedDay: _focusedDay,
                  selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                  onDaySelected: _onDaySelected,
                  eventLoader: _getEventsForDay,
                  calendarFormat: _calendarFormat,
                  onFormatChanged: (format) {
                    if (_calendarFormat != format) {
                      setState(() {
                        _calendarFormat = format;
                      });
                    }
                  },
                  calendarStyle: const CalendarStyle(
                    todayDecoration: BoxDecoration(
                      color: Colors.blueAccent,
                      shape: BoxShape.circle,
                    ),
                    selectedDecoration: BoxDecoration(
                      color: Colors.orangeAccent,
                      shape: BoxShape.circle,
                    ),
                  ),
                  calendarBuilders: CalendarBuilders(
                    markerBuilder: (context, date, events) {
                      if (events.isNotEmpty) {
                        return Positioned(
                          right: 1,
                          bottom: 1,
                          child: _buildEventsMarker(date, events),
                        );
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 8.0),
                Expanded(
                  child: _buildEventList(),
                ),
              ],
            );
          }
        },
      ),
    );
  }

  Widget _buildEventsMarker(DateTime date, List<WorkoutSummary> events) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.blue[400],
      ),
      width: 16.0,
      height: 16.0,
      child: Center(
        child: Text(
          '${events.length}',
          style: const TextStyle().copyWith(
            color: Colors.white,
            fontSize: 12.0,
          ),
        ),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '${twoDigits(duration.inHours)}:$minutes:$seconds';
  }

  Widget _buildEventList() {
    final selectedEvents = _getEventsForDay(_selectedDay!);
    if (selectedEvents.isEmpty) {
      return const Center(
        child: Text("No workouts for this day"),
      );
    }
    return ListView.builder(
      itemCount: selectedEvents.length,
      itemBuilder: (context, index) {
        final summary = selectedEvents[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          child: ListTile(
            title: Text(summary.workoutName),
            subtitle: Text(
                '${DateFormat.yMMMd().add_jm().format(summary.date)} - ${_formatDuration(summary.totalDuration)}'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      WorkoutSummariesScreen(highlightedSummary: summary),
                ),
              );
            },
          ),
        );
      },
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
