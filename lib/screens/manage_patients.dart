import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rbes_for_malaria_diagnosis/screens/diagnosis_screen.dart';

class ManagePatients extends StatefulWidget {
  const ManagePatients({Key? key}) : super(key: key);

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

    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Patients'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$greeting!',
              style: theme.textTheme.headline6,
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
      decoration: InputDecoration(
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
          return ListView.builder(
            shrinkWrap: true,
            itemCount: patients.length,
            itemBuilder: (context, index) {
              final patient = patients[index];
              final patientId = patient.id;
              final patientData = patient.data() as Map<String, dynamic>;
              final patientName = patientData['name'] ?? '';
              final registrationNumber = patientData['registrationNumber'] ?? '';
              final result = patientData['result'] ?? '';
              final role = patientData['role'] ?? '';
              final date = DateFormat.yMMMd().format(DateTime.fromMicrosecondsSinceEpoch(patientData['date']));

              return Card(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16.0),
                    topRight: Radius.circular(16.0),
                    bottomLeft: Radius.circular(0),
                    bottomRight: Radius.circular(0),
                  ),
                ),
                child: ExpansionTile(
                  title: Text(patientName),
                  children: [
                    ListTile(
                      title: Text('Name: $patientName'),
                    ),
                    ListTile(
                      title: Text('Role: $role'),
                    ),
                    ListTile(
                      title: Text('Result: $result'),
                    ),
                    ListTile(
                      title: Text('Registration Number: $registrationNumber'),
                    ),
                    ListTile(
                      title: Text('Date: $date'),
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
