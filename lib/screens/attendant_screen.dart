import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../services/firebase_auth_methods.dart';

class AttendantScreen extends StatefulWidget {
  final String title;
  const AttendantScreen({super.key, required this.title});

  @override
  State<AttendantScreen> createState() => _AttendantScreenState();
}

class _AttendantScreenState extends State<AttendantScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text("Attendant"),
          ElevatedButton(
              onPressed: (){
                FirebaseMethods(FirebaseAuth.instance).logOut();
                context.pop();
                },
              child: const Text("log out")
          )
        ],
      ),
    );
  }
}
