import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rbes_for_malaria_diagnosis/services/auth_service.dart';
import '../services/firebase_auth_methods.dart';
import '../services/user_helper.dart';

class AdminScreen extends StatefulWidget {
  final String title;

  const AdminScreen({super.key, required this.title});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title, style: const TextStyle(color: Colors.white)),
        backgroundColor: Colors.blueGrey[900],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
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
                              icon: const Icon(Icons.edit),
                              onPressed: () {
                                _showEditUserBottomSheet(context, user);
                              },
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
            ElevatedButton(
              child: const Text("Add User"),
              onPressed: () {
                _showAddUserDialog(context);
              },
            ),
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

  void _showEditUserBottomSheet(BuildContext context, DocumentSnapshot userSnapshot) {
    final TextEditingController nameController = TextEditingController(text: userSnapshot['name']);
    final TextEditingController emailController = TextEditingController(text: userSnapshot['email']);
    String? selectedRole = 'patient';
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const Text(
                'Edit User',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: selectedRole,
                onChanged: (newValue) {
                  setState(() {
                    selectedRole = newValue;
                  });
                },
                items: <String>['patient', 'doctor'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  _updateUser(context, userSnapshot.id, nameController.text, emailController.text, selectedRole!);
                  Navigator.pop(context);
                },
                child: const Text('Update'),
              ),
            ],
          ),
        );
      },
    );

  }

  void _updateUser(BuildContext context, String userId, String newName, String newEmail, String selectedRole) {
    FirebaseFirestore.instance.collection("users").doc(userId).update({
      'name': newName,
      'email': newEmail,
      'role': selectedRole
    }).then((value) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('User updated successfully')));
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to update user: $error')));
    });
  }

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

  void _deleteUser(BuildContext context, String userId) {
    FirebaseFirestore.instance.collection("users").doc(userId).delete().then((value) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('User deleted successfully')));
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to delete user: $error')));
    });
  }

  void _addUser(BuildContext context, String email, String password){
    final user = AuthService.signupWithEmail(
        email: email,
        password: password,
        firstName: "",
        lastName: "",
        context: context
    );

    UserHelper.saveUser(user);
  }

  void _showAddUserDialog(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const Text(
                  'Add User',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: passwordController,
                  decoration: const InputDecoration(labelText: 'Password'),
                  obscureText: true,
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    _addUser(context, emailController.text, passwordController.text);
                    Navigator.pop(context);
                  },
                  child: const Text('Add'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
