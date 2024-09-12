import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../common/loading_indicator.dart';
import '../../services/user_helper.dart';
import '../admin_dashboard/admin_dashboard.dart';
import '../manage_patients/manage_patients.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              return _buildSignupForm(context);
            }
          },
        ),
      ),
    );
  }

  Widget _buildSignupForm(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Sign Up',
              style: Theme.of(context).textTheme.displayMedium,
            ),
            const SizedBox(height: 30),
            _buildTextField(
              controller: _firstNameController,
              label: 'First Name',
              icon: Icons.person,
              textInputAction: TextInputAction.next,
              validator: (value) => value!.isEmpty ? 'First name is required' : null,
              onFieldSubmitted: (value) => FocusScope.of(context).nextFocus(),
            ),
            const SizedBox(height: 20),
            _buildTextField(
              controller: _lastNameController,
              label: 'Last Name',
              icon: Icons.person_outline,
              textInputAction: TextInputAction.next,
              validator: (value) => value!.isEmpty ? 'Last name is required' : null,
              onFieldSubmitted: (value) => FocusScope.of(context).nextFocus(),
            ),
            const SizedBox(height: 20),
            _buildTextField(
              controller: _emailController,
              label: 'Email',
              icon: Icons.email,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Email is required';
                }
                if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                  return 'Enter a valid email address';
                }
                return null;
              },
              onFieldSubmitted: (value) => FocusScope.of(context).nextFocus(),
            ),
            const SizedBox(height: 20),
            _buildTextField(
              controller: _passwordController,
              label: 'Password',
              icon: Icons.lock,
              obscureText: true,
              textInputAction: TextInputAction.next,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Password is required';
                }
                if (value.length < 6) {
                  return 'Password must be at least 6 characters long';
                }
                return null;
              },
              onFieldSubmitted: (value) => FocusScope.of(context).nextFocus(),
            ),
            const SizedBox(height: 20),
            _buildTextField(
              controller: _confirmPasswordController,
              label: 'Confirm Password',
              icon: Icons.lock_outline,
              obscureText: true,
              textInputAction: TextInputAction.done,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please confirm your password';
                }
                if (value != _passwordController.text) {
                  return 'Passwords do not match';
                }
                return null;
              },
              onFieldSubmitted: (value) => _submitForm(),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () async {
                _submitForm();
              },
              style: ElevatedButton.styleFrom(
                shape: Theme.of(context).elevatedButtonTheme.style?.shape?.resolve({}) ??
                    RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                padding: Theme.of(context).elevatedButtonTheme.style?.padding?.resolve({}) ??
                    const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Theme.of(context).elevatedButtonTheme.style?.backgroundColor?.resolve({}) ??
                    Colors.blueGrey[900],
              ),
              child: Text(
                'Sign Up',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white),
              ),
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () {
                context.push('/sign-in');
              },
              child: Text(
                'Already have an account? Sign In',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      try {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );
        // User will be automatically redirected by StreamBuilder
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    String? Function(String?)? validator,
    TextInputAction textInputAction = TextInputAction.next,
    void Function(String)? onFieldSubmitted,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      textInputAction: textInputAction,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Theme.of(context).inputDecorationTheme.prefixIconColor),
        labelText: label,
        labelStyle: Theme.of(context).inputDecorationTheme.labelStyle,
        filled: true,
        fillColor: Theme.of(context).inputDecorationTheme.fillColor,
        border: Theme.of(context).inputDecorationTheme.border,
        focusedBorder: Theme.of(context).inputDecorationTheme.focusedBorder,
      ),
      validator: validator,
      onFieldSubmitted: onFieldSubmitted,
    );
  }
}
