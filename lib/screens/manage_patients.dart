import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rbes_for_malaria_diagnosis/services/patient_helper.dart';
import '../widgets/searchbox.dart';

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
              style: theme.textTheme.titleLarge?.copyWith(
                color: Colors.blueGrey[900],
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16.0),
            SearchBox(
              hintText: 'Search patients...',
              icon: Icons.search,
              onChanged: (value) {
                setState(() {});
              },
              controller: _searchController,
            ),
            const SizedBox(height: 26.0),
            _buildPatientList(),
          ],
        ),
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
            return const Center(
              child: Text(
                'All registered patients will appear here.',
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 18,
                ),
                textAlign: TextAlign.center,
              ),
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
                  borderRadius: BorderRadius.all(Radius.circular(16.0)),
                ),
                child: ExpansionTile(
                  iconColor: Colors.white,
                  collapsedIconColor: Colors.white,
                  title: Text(
                    patientName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  children: [
                    ListTile(
                      title: Text(
                        'Name: $patientName',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    ListTile(
                      title: Text(
                        'Role: $role',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    ListTile(
                      title: Text(
                        'Result: $result',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    ListTile(
                      title: Text(
                        'Registration Number: $registrationNumber',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    ListTile(
                      title: Text(
                        'Date: $date',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        children: [
                          TextButton(
                            onPressed: () {
                              // Navigate to DiagnosisScreen with patient ID
                              context.push('/diagnosis/$patientId');
                            },
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.blueGrey[900],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                            child: const Text(
                              'Diagnose',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16.0),
                          TextButton(
                            onPressed: () {
                              _deletePatient(patientId);
                            },
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.red[700],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                            child: const Text(
                              'Delete Patient',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
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

  void _deletePatient(String patientId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: const Text('Are you sure you want to delete this patient?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                context.pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                context.pop(); // Close the dialog
                PatientHelper.deletePatient(patientId: patientId, context: context);
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
