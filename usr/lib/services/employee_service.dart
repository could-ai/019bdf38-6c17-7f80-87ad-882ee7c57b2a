import 'package:flutter/material.dart';
import '../models/employee_model.dart';

class EmployeeService extends ChangeNotifier {
  static final EmployeeService _instance = EmployeeService._internal();
  factory EmployeeService() => _instance;
  EmployeeService._internal() {
    _initMockData();
  }

  final List<EmployeeModel> _employees = [];
  List<EmployeeModel> get employees => List.unmodifiable(_employees);

  void _initMockData() {
    _employees.addAll([
      EmployeeModel(
        id: '1',
        name: 'Alice Johnson',
        role: 'Software Engineer',
        department: 'IT',
        email: 'alice@company.com',
        joiningDate: DateTime(2022, 1, 15),
      ),
      EmployeeModel(
        id: '2',
        name: 'Bob Smith',
        role: 'Product Manager',
        department: 'Product',
        email: 'bob@company.com',
        joiningDate: DateTime(2021, 5, 20),
      ),
      EmployeeModel(
        id: '3',
        name: 'Charlie Brown',
        role: 'Designer',
        department: 'Design',
        email: 'charlie@company.com',
        joiningDate: DateTime(2023, 3, 10),
      ),
    ]);
  }

  void addEmployee(EmployeeModel employee) {
    _employees.add(employee);
    notifyListeners();
  }
}
