import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../services/user_helper.dart';

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
      appBar: AppBar(
        title: Text('Edit Staff Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Staff ID: ${widget.staffId}'),
            SizedBox(height: 10),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _saveChanges(context, widget.staffId, _nameController.text, _emailController.text);
              },
              child: Text('Save Changes'),
            ),
          ],
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
