import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:workout_timer_app/models/workout_summary.dart';

class WorkoutCalendar extends StatelessWidget {
  final DateTime focusedDay;
  final DateTime? selectedDay;
  final CalendarFormat calendarFormat;
  final Map<DateTime, List<WorkoutSummary>> events;
  final Function(DateTime, DateTime) onDaySelected;
  final Function(CalendarFormat) onFormatChanged;
  final List<WorkoutSummary> Function(DateTime) getEventsForDay;

  const WorkoutCalendar({
    super.key,
    required this.focusedDay,
    required this.selectedDay,
    required this.calendarFormat,
    required this.events,
    required this.onDaySelected,
    required this.onFormatChanged,
    required this.getEventsForDay,
  });

  @override
  Widget build(BuildContext context) {
    return TableCalendar<WorkoutSummary>(
      firstDay: DateTime.utc(2020, 1, 1),
      lastDay: DateTime.utc(2030, 12, 31),
      focusedDay: focusedDay,
      selectedDayPredicate: (day) => isSameDay(selectedDay, day),
      onDaySelected: onDaySelected,
      eventLoader: getEventsForDay,
      calendarFormat: calendarFormat,
      onFormatChanged: onFormatChanged,
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
}
