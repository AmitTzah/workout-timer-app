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
  final Function(DateTime) onPageChanged;
  final List<WorkoutSummary> Function(DateTime) getEventsForDay;

  const WorkoutCalendar({
    super.key,
    required this.focusedDay,
    required this.selectedDay,
    required this.calendarFormat,
    required this.events,
    required this.onDaySelected,
    required this.onFormatChanged,
    required this.onPageChanged,
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
      onPageChanged: onPageChanged,
      headerStyle: const HeaderStyle(
        formatButtonVisible: true,
        titleCentered: true,
      ),
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
        headerTitleBuilder: (context, date) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // IconButton(
              //   icon: const Icon(Icons.chevron_left),
              //   onPressed: () {
              //     onPageChanged(DateTime(date.year, date.month - 1));
              //   },
              // ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  DropdownButton<int>(
                    value: date.year,
                    onChanged: (int? newValue) {
                      if (newValue != null) {
                        onPageChanged(DateTime(newValue, date.month));
                      }
                    },
                    items: List.generate(11, (index) => 2020 + index)
                        .map<DropdownMenuItem<int>>((int value) {
                      return DropdownMenuItem<int>(
                        value: value,
                        child: Text(value.toString()),
                      );
                    }).toList(),
                  ),
                  const SizedBox(width: 10),
                  DropdownButton<int>(
                    value: date.month,
                    onChanged: (int? newValue) {
                      if (newValue != null) {
                        onPageChanged(DateTime(date.year, newValue));
                      }
                    },
                    items: List.generate(12, (index) => index + 1)
                        .map<DropdownMenuItem<int>>((int value) {
                      return DropdownMenuItem<int>(
                        value: value,
                        child: Text(
                          [
                            'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
                            'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
                          ][value - 1],
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.today),
                onPressed: () {
                  onPageChanged(DateTime.now());
                },
              ),
              // IconButton(
              //   icon: const Icon(Icons.chevron_right),
              //   onPressed: () {
              //     onPageChanged(DateTime(date.year, date.month + 1));
              //   },
              // ),
            ],
          );
        },
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
