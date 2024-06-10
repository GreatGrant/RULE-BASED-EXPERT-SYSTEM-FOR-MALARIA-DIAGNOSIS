import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../services/user_helper.dart';

class EditStaffDetailsPage extends StatefulWidget {
  final String staffId;
  final String name;
  final String email;
  final String department;

  const EditStaffDetailsPage({
    super.key,
    required this.staffId,
    required this.name,
    required this.email,
    required this.department,
  });

  @override
  State<EditStaffDetailsPage> createState() => _EditStaffDetailsPageState();
}

class _EditStaffDetailsPageState extends State<EditStaffDetailsPage> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late String _selectedDepartment;

  final List<String> _departments = [
    'Pediatrics Department',
    'Internal Medicine Department',
    'Maternity Department'
  ];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.name);
    _emailController = TextEditingController(text: widget.email);
    _selectedDepartment = _departments.contains(widget.department) ? widget.department : _departments.first;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[100],
      appBar: AppBar(
        title: const Text('Edit Staff Details'),
        backgroundColor: Colors.blueGrey[100],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Staff ID: ${widget.staffId}'),
              const SizedBox(height: 10),
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  labelStyle: TextStyle(color: Colors.blueGrey),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.green),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  labelStyle: TextStyle(color: Colors.blueGrey),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.green),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: _selectedDepartment,
                decoration: const InputDecoration(
                  labelText: 'Department',
                  labelStyle: TextStyle(color: Colors.blueGrey),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.green),
                  ),
                ),
                items: _departments.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedDepartment = newValue!;
                  });
                },
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    _saveChanges(context, widget.staffId, _nameController.text, _emailController.text, _selectedDepartment);
                  },
                  child: const Text('Save Changes', style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }
}

void _saveChanges(BuildContext context, String staffId, String name, String email, String department) {
  UserHelper.updateStaff(
    context: context,
    name: name,
    email: email,
    department: department,
    staffId: staffId,
  );
  context.pop();
}
