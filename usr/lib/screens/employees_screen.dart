import 'package:flutter/material.dart';
import '../services/employee_service.dart';

class EmployeesScreen extends StatelessWidget {
  const EmployeesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: EmployeeService(),
      builder: (context, child) {
        final employees = EmployeeService().employees;
        if (employees.isEmpty) {
          return const Center(
            child: Text('No employees found. Add one to get started.'),
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: employees.length,
          itemBuilder: (context, index) {
            final employee = employees[index];
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
                  child: Text(
                    employee.name.isNotEmpty ? employee.name[0].toUpperCase() : '?',
                    style: TextStyle(color: Theme.of(context).primaryColor),
                  ),
                ),
                title: Text(
                  employee.name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text('${employee.role} • ${employee.department}'),
                trailing: IconButton(
                  icon: const Icon(Icons.email_outlined),
                  onPressed: () {
                    // Placeholder for email action
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Email to ${employee.email}')),
                    );
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }
}
