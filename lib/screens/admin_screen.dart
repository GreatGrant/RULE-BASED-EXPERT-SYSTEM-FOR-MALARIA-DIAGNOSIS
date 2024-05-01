import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../services/firebase_auth_methods.dart';

class AdminScreen extends StatelessWidget {
  final String title;

  const AdminScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title, style: const TextStyle(color: Colors.white)),
        backgroundColor: Colors.blueGrey[900],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // View Users
            StreamBuilder(
              stream: FirebaseFirestore.instance.collection("users").snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasData && snapshot.data != null) {
                  final docs = snapshot.data!.docs;
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: docs.length,
                    itemBuilder: (BuildContext context, int index) {
                      final user = docs[index];
                      return ListTile(
                        title: Row(
                          children: [
                            Expanded(
                              child: Text(user['name'] ?? user['email']),
                            ),
                            IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                _showDeleteConfirmationDialog(context, user.id);
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
            // Add User Button
            ElevatedButton(
              child: const Text("Add User"),
              onPressed: () {
                _showAddUserDialog(context);
              },
            ),
            // Log out Button
            ElevatedButton(
              child: const Text("Log out"),
              onPressed: () {
                FirebaseMethods(FirebaseAuth.instance).logOut();
              },
            )
          ],
        ),
      ),
    );
  }

  // Method to show dialog for adding a user
  void _showAddUserDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Add User"),
          content: const SingleChildScrollView(
            child: Column(
              children: [
                // Add form fields to input user details
                // For example:
                // TextFormField(
                //   decoration: InputDecoration(labelText: 'Email'),
                //   keyboardType: TextInputType.emailAddress,
                //   controller: _emailController,
                // ),
                // TextFormField(
                //   decoration: InputDecoration(labelText: 'Password'),
                //   obscureText: true,
                //   controller: _passwordController,
                // ),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                // Implement adding user functionality here
                // For example: _addUser(_emailController.text, _passwordController.text);
                Navigator.of(context).pop();
              },
              child: const Text("Add"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancel"),
            ),
          ],
        );
      },
    );
  }

  // Method to show delete confirmation dialog
  void _showDeleteConfirmationDialog(BuildContext context, String userId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Delete User"),
          content: const Text("Are you sure you want to delete this user?"),
          actions: [
            ElevatedButton(
              onPressed: () {
                _deleteUser(context, userId);
                Navigator.of(context).pop();
              },
              child: const Text("Yes"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("No"),
            ),
          ],
        );
      },
    );
  }

  // Method to delete user
  void _deleteUser(BuildContext context, String userId) {
    FirebaseFirestore.instance.collection("users").doc(userId).delete().then((value) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('User deleted successfully')));
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to delete user: $error')));
    });
  }
}
