import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';
import 'package:rbes_for_malaria_diagnosis/services/user_helper.dart';

import 'edit_staff_details.dart';

class ManageStaff extends StatefulWidget {
  const ManageStaff({super.key});

  @override
  State<ManageStaff> createState() => _ManageStaffState();
}

class _ManageStaffState extends State<ManageStaff> {
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currentTime = DateTime.now();
    String greeting = _getGreeting(currentTime.hour);

    return Scaffold(
      backgroundColor: Colors.blueGrey[100],
      appBar: AppBar(
        title: const Text('Manage Staff'),
        backgroundColor: Colors.blueGrey[100],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$greeting!',
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: 16.0),
            _buildSearchBox(),
            const SizedBox(height: 16.0),
            _buildStaffList(),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBox() {
    return TextField(
      controller: _searchController,
      onChanged: (value) {
        setState(() {}); // Trigger rebuild when search text changes
      },
      decoration: const InputDecoration(
        prefixIcon: Icon(Icons.search),
        hintText: 'Search staff...',
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget _buildStaffList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('staff').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData) {
          final List<DocumentSnapshot> staff = snapshot.data!.docs;
          final searchQuery = _searchController.text.toLowerCase();
          final filteredStaff = staff.where((staff) {
            final staffData = staff.data() as Map<String, dynamic>;
            final staffName = staffData['name'] ?? '';
            return staffName.toLowerCase().contains(searchQuery);
          }).toList();

          if (filteredStaff.isEmpty) {
            return const Center(
              child: Text('No staff found.'),
            );
          }

          return ListView.builder(
            shrinkWrap: true,
            itemCount: filteredStaff.length,
            itemBuilder: (context, index) {
              final staff = filteredStaff[index];
              final staffData = staff.data() as Map<String, dynamic>;
              final staffName = staffData['name'] ?? '';
              final email = staffData['email'] ?? '';

              return Card(
                color: Colors.blueGrey[700],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: ListTile(
                  title: Text(staffName, style: const TextStyle(color: Colors.white)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10,),
                      Text('Email: $email', style: const TextStyle(color: Colors.white)),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.white),
                        onPressed: () {
                          _editStaff(staff);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.white),
                        onPressed: () {
                          _deleteStaff(staff);
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  void _editStaff(DocumentSnapshot staff) {
    final staffId = staff.id;
    final name = staff['name'];
    final email = staff['email'];

    // Construct the route path with the staffId as a parameter
    final routePath = '/edit_staff/$staffId';

    context.push(Uri(path: routePath, queryParameters: {'name': name, 'email': email}).toString());
  }



  void _deleteStaff(DocumentSnapshot staff) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: const Text('Are you sure you want to delete this staff member?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                UserHelper.deleteStaff(context, staff.id); // Call the delete method
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  String _getGreeting(int hour) {
    if (hour < 12) {
      return 'Good morning';
    } else if (hour < 18) {
      return 'Good afternoon';
    } else {
      return 'Good evening';
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
