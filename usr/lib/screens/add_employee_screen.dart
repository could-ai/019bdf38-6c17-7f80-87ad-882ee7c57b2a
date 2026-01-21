import 'package:flutter/material.dart';
import '../models/employee_model.dart';
import '../services/employee_service.dart';

class AddEmployeeScreen extends StatefulWidget {
  const AddEmployeeScreen({super.key});

  @override
  State<AddEmployeeScreen> createState() => _AddEmployeeScreenState();
}

class _AddEmployeeScreenState extends State<AddEmployeeScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _roleController = TextEditingController();
  final TextEditingController _deptController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _roleController.dispose();
    _deptController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _submitEmployee() {
    if (_formKey.currentState!.validate()) {
      final newEmployee = EmployeeModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text,
        role: _roleController.text,
        department: _deptController.text,
        email: _emailController.text,
        joiningDate: DateTime.now(),
      );

      EmployeeService().addEmployee(newEmployee);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Employee added successfully!')),
      );

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Employee'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Please enter name' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _roleController,
                decoration: const InputDecoration(
                  labelText: 'Job Role',
                  prefixIcon: Icon(Icons.work),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Please enter role' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _deptController,
                decoration: const InputDecoration(
                  labelText: 'Department',
                  prefixIcon: Icon(Icons.business),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Please enter department' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email Address',
                  prefixIcon: Icon(Icons.email),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter email';
                  }
                  if (!value.contains('@')) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _submitEmployee,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Add Employee'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
