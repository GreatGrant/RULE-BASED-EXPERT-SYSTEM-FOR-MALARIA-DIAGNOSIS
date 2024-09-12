import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rbes_for_malaria_diagnosis/util/show_snackbar.dart';
import '../../app_theme.dart';
import '../../common/loading_indicator.dart';
import '../../services/user_helper.dart';
import '../admin_dashboard/admin_dashboard.dart';
import '../manage_patients/manage_patients.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: appTheme(),
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: Center(
          child: StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, authSnapshot) {
              if (authSnapshot.hasData && authSnapshot.data != null) {
                UserHelper.saveUser(authSnapshot.data!);
                return StreamBuilder<DocumentSnapshot>(
                  stream: UserHelper.fetchUserDocument(authSnapshot.data!.uid),
                  builder: (BuildContext context, userDocSnapshot) {
                    if (userDocSnapshot.hasData && userDocSnapshot.data != null) {
                      final userDoc = userDocSnapshot.data!;
                      final user = userDoc.data() as Map<String, dynamic>;
                      if (user['role'] == 'admin') {
                        return const AdminDashboard();
                      } else {
                        return const ManagePatients();
                      }
                    } else {
                      return const LoadingIndicator();
                    }
                  },
                );
              } else {
                return _buildSignInForm(context);
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildSignInForm(BuildContext context) {
    final _emailController = TextEditingController();
    final _passwordController = TextEditingController();
    final _formKey = GlobalKey<FormState>();

    final FocusNode _passwordFocusNode = FocusNode();

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Sign In',
              style: Theme.of(context).textTheme.displayMedium,
            ),
            const SizedBox(height: 30),
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.email, color: Theme.of(context).iconTheme.color),
                labelText: 'Email',
                filled: true,
                fillColor: Theme.of(context).inputDecorationTheme.fillColor,
                border: Theme.of(context).inputDecorationTheme.border,
                focusedBorder: Theme.of(context).inputDecorationTheme.focusedBorder,
                labelStyle: Theme.of(context).inputDecorationTheme.labelStyle,
              ),
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (_) {
                FocusScope.of(context).requestFocus(_passwordFocusNode);
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Email is required';
                }
                if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                  return 'Enter a valid email address';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _passwordController,
              focusNode: _passwordFocusNode,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.lock, color: Theme.of(context).iconTheme.color),
                labelText: 'Password',
                filled: true,
                fillColor: Theme.of(context).inputDecorationTheme.fillColor,
                border: Theme.of(context).inputDecorationTheme.border,
                focusedBorder: Theme.of(context).inputDecorationTheme.focusedBorder,
                labelStyle: Theme.of(context).inputDecorationTheme.labelStyle,
              ),
              obscureText: true,
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (_) async {
                if (_formKey.currentState!.validate()) {
                  try {
                    await FirebaseAuth.instance.signInWithEmailAndPassword(
                      email: _emailController.text,
                      password: _passwordController.text,
                    );
                  } catch (e) {
                    if (!context.mounted) return;
                    showSnackBar(context, 'Error: $e');
                  }
                }
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Password is required';
                }
                return null;
              },
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  try {
                    await FirebaseAuth.instance.signInWithEmailAndPassword(
                      email: _emailController.text,
                      password: _passwordController.text,
                    );
                  } catch (e) {
                    if (!context.mounted) return;
                    showSnackBar(context, 'Error: $e');
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                backgroundColor: Theme.of(context).elevatedButtonTheme.style?.backgroundColor?.resolve({}),
                shape: Theme.of(context).elevatedButtonTheme.style?.shape?.resolve({}) ?? RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text(
                'Sign In',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () {
                // Navigate to Sign Up Screen
                context.push('/sign-up'); // Ensure the route exists
              },
              child: Text(
                'Don\'t have an account? Sign Up',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            TextButton(
              onPressed: () {
                // Navigate to Forgot Password Screen
                context.push('/forgot_password'); // Ensure the route exists
              },
              child: Text(
                'Forgot Password?',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
