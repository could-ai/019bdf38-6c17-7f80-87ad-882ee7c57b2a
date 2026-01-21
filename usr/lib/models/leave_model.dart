enum LeaveType {
  vacation,
  sick,
  personal,
  remoteWork,
}

enum LeaveStatus {
  pending,
  approved,
  rejected,
}

class LeaveModel {
  final String id;
  final String employeeName;
  final DateTime startDate;
  final DateTime endDate;
  final LeaveType type;
  final LeaveStatus status;
  final String reason;

  LeaveModel({
    required this.id,
    required this.employeeName,
    required this.startDate,
    required this.endDate,
    required this.type,
    this.status = LeaveStatus.pending,
    required this.reason,
  });
}
