import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rbes_for_malaria_diagnosis/screens/diagnosis_screen.dart';

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
              style: theme.textTheme.headline5,
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
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.search),
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
              final role = staffData['role'] ?? '';

              return Card(
                color: Colors.blueGrey[700],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: ListTile(
                  title: Text(staffName, style: const TextStyle(color: Colors.white)),
                  subtitle: Text(role, style: const TextStyle(color: Colors.white)),
                  trailing: IconButton(
                    icon: const Icon(Icons.arrow_forward, color: Colors.white),
                    onPressed: () {
                      // Navigate to DiagnosisScreen with staff ID
                      context.push('/diagnosis/${staff.id}');
                    },
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
