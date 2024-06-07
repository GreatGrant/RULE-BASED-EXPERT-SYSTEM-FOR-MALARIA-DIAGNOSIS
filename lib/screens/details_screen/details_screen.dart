import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DetailsScreen extends StatelessWidget {
  final DocumentSnapshot user;

  const DetailsScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Name: ${user['name']}'),
            const SizedBox(height: 8),
            Text('Age: ${user['age']}'),
            const SizedBox(height: 8),
            if (user['role'] == 'patient') ...[
              Text('Registration Number: ${user['registrationNumber']}'),
              const SizedBox(height: 8),
              Text('Result: ${user['result']}'),
              const SizedBox(height: 8),
              Text('Gender: ${user['gender']}'),
              const SizedBox(height: 8),
              Text('Date: ${DateTime.fromMillisecondsSinceEpoch(user['date']).toLocal()}'),
            ] else ...[
              Text('Email: ${user['email']}'),
              const SizedBox(height: 8),
              Text('Department: ${user['department']}'),
            ],
          ],
        ),
      ),
    );
  }
}
