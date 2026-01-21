import 'package:flutter/material.dart';
import '../models/leave_model.dart';

class LeaveService extends ChangeNotifier {
  // Singleton pattern
  static final LeaveService _instance = LeaveService._internal();
  factory LeaveService() => _instance;
  LeaveService._internal() {
    _initMockData();
  }

  final List<LeaveModel> _leaves = [];

  List<LeaveModel> get leaves => List.unmodifiable(_leaves);

  void _initMockData() {
    final now = DateTime.now();
    _leaves.addAll([
      LeaveModel(
        id: '1',
        employeeName: 'Alice Johnson',
        startDate: now,
        endDate: now.add(const Duration(days: 2)),
        type: LeaveType.vacation,
        status: LeaveStatus.approved,
        reason: 'Family trip',
      ),
      LeaveModel(
        id: '2',
        employeeName: 'Bob Smith',
        startDate: now.add(const Duration(days: 5)),
        endDate: now.add(const Duration(days: 6)),
        type: LeaveType.sick,
        status: LeaveStatus.pending,
        reason: 'Medical appointment',
      ),
      LeaveModel(
        id: '3',
        employeeName: 'Charlie Brown',
        startDate: now.subtract(const Duration(days: 3)),
        endDate: now.subtract(const Duration(days: 1)),
        type: LeaveType.personal,
        status: LeaveStatus.approved,
        reason: 'Personal matters',
      ),
    ]);
  }

  void addLeave(LeaveModel leave) {
    _leaves.add(leave);
    notifyListeners();
  }

  void updateLeaveStatus(String id, LeaveStatus status) {
    final index = _leaves.indexWhere((l) => l.id == id);
    if (index != -1) {
      final oldLeave = _leaves[index];
      _leaves[index] = LeaveModel(
        id: oldLeave.id,
        employeeName: oldLeave.employeeName,
        startDate: oldLeave.startDate,
        endDate: oldLeave.endDate,
        type: oldLeave.type,
        status: status,
        reason: oldLeave.reason,
      );
      notifyListeners();
    }
  }

  List<LeaveModel> getLeavesForDay(DateTime day) {
    return _leaves.where((leave) {
      // Normalize dates to ignore time components for comparison
      final start = DateTime(leave.startDate.year, leave.startDate.month, leave.startDate.day);
      final end = DateTime(leave.endDate.year, leave.endDate.month, leave.endDate.day);
      final check = DateTime(day.year, day.month, day.day);
      return (check.isAtSameMomentAs(start) || check.isAfter(start)) &&
             (check.isAtSameMomentAs(end) || check.isBefore(end));
    }).toList();
  }
}
