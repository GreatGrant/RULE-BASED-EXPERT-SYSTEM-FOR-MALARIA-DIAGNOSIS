import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../services/user_helper.dart';

class EditStaffDetailsPage extends StatefulWidget {
  final String staffId;
  final String name;
  final String email;

  const EditStaffDetailsPage({
    super.key,
    required this.staffId,
    required this.name,
    required this.email
  });

  @override
  State<EditStaffDetailsPage> createState() => _EditStaffDetailsPageState();
}

class _EditStaffDetailsPageState extends State<EditStaffDetailsPage> {
  late TextEditingController _nameController = TextEditingController(text: widget.name);
  late TextEditingController _emailController = TextEditingController(text: widget.email);

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.name);
    _emailController = TextEditingController(text: widget.email);
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
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    _saveChanges(context, widget.staffId, _nameController.text, _emailController.text);
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

void _saveChanges(BuildContext context, String staffId, String name, String email) {
  UserHelper.updateStaff(context: context, name: name, email: email, staffId: staffId);
  context.pop();
}
