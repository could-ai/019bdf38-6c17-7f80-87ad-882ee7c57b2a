import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import '../models/leave_model.dart';
import '../services/leave_service.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  late final ValueNotifier<List<LeaveModel>> _selectedEvents;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  final LeaveService _leaveService = LeaveService();

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(_getLeavesForDay(_selectedDay!));
    
    // Listen to service changes to update UI
    _leaveService.addListener(_updateEvents);
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    _leaveService.removeListener(_updateEvents);
    super.dispose();
  }

  void _updateEvents() {
    if (_selectedDay != null) {
      _selectedEvents.value = _getLeavesForDay(_selectedDay!);
    }
    setState(() {}); // Rebuild calendar to show new markers
  }

  List<LeaveModel> _getLeavesForDay(DateTime day) {
    return _leaveService.getLeavesForDay(day);
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
      });
      _selectedEvents.value = _getLeavesForDay(selectedDay);
    }
  }

  Color _getStatusColor(LeaveStatus status) {
    switch (status) {
      case LeaveStatus.approved:
        return Colors.green;
      case LeaveStatus.pending:
        return Colors.orange;
      case LeaveStatus.rejected:
        return Colors.red;
    }
  }

  Color _getTypeColor(LeaveType type) {
    switch (type) {
      case LeaveType.vacation:
        return Colors.blue;
      case LeaveType.sick:
        return Colors.redAccent;
      case LeaveType.personal:
        return Colors.purple;
      case LeaveType.remoteWork:
        return Colors.teal;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          margin: const EdgeInsets.all(16.0),
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TableCalendar<LeaveModel>(
              firstDay: DateTime.utc(2020, 10, 16),
              lastDay: DateTime.utc(2030, 3, 14),
              focusedDay: _focusedDay,
              calendarFormat: _calendarFormat,
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              eventLoader: _getLeavesForDay,
              startingDayOfWeek: StartingDayOfWeek.monday,
              calendarStyle: const CalendarStyle(
                outsideDaysVisible: false,
                markerDecoration: BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                ),
              ),
              onDaySelected: _onDaySelected,
              onFormatChanged: (format) {
                if (_calendarFormat != format) {
                  setState(() {
                    _calendarFormat = format;
                  });
                }
              },
              onPageChanged: (focusedDay) {
                _focusedDay = focusedDay;
              },
              calendarBuilders: CalendarBuilders(
                markerBuilder: (context, date, events) {
                  if (events.isEmpty) return null;
                  return Positioned(
                    bottom: 1,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: events.take(3).map((event) {
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 1.0),
                          width: 7.0,
                          height: 7.0,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _getTypeColor(event.type),
                          ),
                        );
                      }).toList(),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
        const SizedBox(height: 8.0),
        Expanded(
          child: ValueListenableBuilder<List<LeaveModel>>(
            valueListenable: _selectedEvents,
            builder: (context, value, _) {
              if (value.isEmpty) {
                return const Center(
                  child: Text('No leaves scheduled for this day.'),
                );
              }
              return ListView.builder(
                itemCount: value.length,
                itemBuilder: (context, index) {
                  final leave = value[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: _getTypeColor(leave.type).withOpacity(0.2),
                        child: Icon(
                          Icons.person,
                          color: _getTypeColor(leave.type),
                        ),
                      ),
                      title: Text(leave.employeeName),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('${leave.type.name.toUpperCase()} • ${leave.reason}'),
                          Text(
                            '${DateFormat.yMMMd().format(leave.startDate)} - ${DateFormat.yMMMd().format(leave.endDate)}',
                            style: const TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                      trailing: Chip(
                        label: Text(
                          leave.status.name.toUpperCase(),
                          style: const TextStyle(color: Colors.white, fontSize: 10),
                        ),
                        backgroundColor: _getStatusColor(leave.status),
                        padding: EdgeInsets.zero,
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
