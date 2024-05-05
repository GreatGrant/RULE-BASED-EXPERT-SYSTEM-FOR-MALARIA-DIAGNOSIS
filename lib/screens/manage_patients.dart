import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rbes_for_malaria_diagnosis/screens/diagnosis_screen.dart';

class ManagePatients extends StatefulWidget {
  const ManagePatients({super.key});

  @override
  State<ManagePatients> createState() => _ManagePatientsState();
}

class _ManagePatientsState extends State<ManagePatients> {
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
    final FirebaseAuth auth = FirebaseAuth.instance;

    return Scaffold(
      backgroundColor: Colors.blueGrey[100],
      appBar: AppBar(
        title: const Text('Manage Patients'),
        backgroundColor: Colors.blueGrey[100],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$greeting, ${auth.currentUser?.displayName ?? ''}!',
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: 16.0),
            _buildSearchBox(),
            const SizedBox(height: 16.0),
            _buildPatientList(),
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
        hintText: 'Search patients...',
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget _buildPatientList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('patients').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData) {
          final List<DocumentSnapshot> patients = snapshot.data!.docs;
          final searchQuery = _searchController.text.toLowerCase();
          final filteredPatients = patients.where((patient) {
            final patientData = patient.data() as Map<String, dynamic>;
            final patientName = patientData['name'] ?? '';
            return patientName.toLowerCase().contains(searchQuery);
          }).toList();

          if (filteredPatients.isEmpty) {
            return Center(
              child: Text('No user found.'),
            );
          }

          return ListView.builder(
            shrinkWrap: true,
            itemCount: filteredPatients.length,
            itemBuilder: (context, index) {
              final patient = filteredPatients[index];
              final patientId = patient.id;
              final patientData = patient.data() as Map<String, dynamic>;
              final patientName = patientData['name'] ?? '';
              final registrationNumber = patientData['registrationNumber'] ?? '';
              final result = patientData['result'] ?? '';
              final role = patientData['role'] ?? '';
              final date = DateFormat.yMMMd().format(DateTime.fromMicrosecondsSinceEpoch(patientData['date']));

              return Card(
                color: Colors.blueGrey[700],
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16.0),
                    topRight: Radius.circular(16.0),
                    bottomLeft: Radius.circular(0),
                    bottomRight: Radius.circular(0),
                  ),
                ),
                child: ExpansionTile(
                  iconColor: Colors.white,
                  collapsedIconColor: Colors.white,
                  // trailing: const Icon(Icons.arrow_drop_down, color: Colors.white),
                  title: Text(patientName, style: const TextStyle(color: Colors.white),),
                  children: [
                    ListTile(
                      title: Text('Name: $patientName', style: const TextStyle(color: Colors.white),),
                    ),
                    ListTile(
                      title: Text('Role: $role', style: const TextStyle(color: Colors.white),),
                    ),
                    ListTile(
                      title: Text('Result: $result', style: const TextStyle(color: Colors.white),),
                    ),
                    ListTile(
                      title: Text('Registration Number: $registrationNumber', style: const TextStyle(color: Colors.white),),
                    ),
                    ListTile(
                      title: Text('Date: $date', style: const TextStyle(color: Colors.white),),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: TextButton(
                        onPressed: () {
                          // Navigate to DiagnosisScreen with patient ID
                          context.go('/diagnosis/$patientId');
                        },
                        child: const Text(
                          'Diagonise',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20
                          ),
                        ),
                      ),
                    ),
                  ],
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
