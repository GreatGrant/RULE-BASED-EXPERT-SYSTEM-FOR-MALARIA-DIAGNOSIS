import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'auth_button.dart';
import '../../../services/auth_service.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void loginUser(String email, String password, BuildContext context) {
    AuthService.signInWithEmail(
      context: context,
      email: email,
      password: password,
    );
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            "Sign in to your account.",
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _emailController,
            decoration: const InputDecoration(
              hintText: 'Enter your email',
              labelText: 'Email',
              labelStyle: TextStyle(color: Colors.blueGrey),
              prefixIcon: Icon(Icons.email),
              border: OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.green),
              ),
            ),
          ),
          const SizedBox(height: 20),
          TextFormField(
            obscureText: true,
            controller: _passwordController,
            decoration:  const InputDecoration(
              hintText: 'Enter your password',
              labelText: 'Password',
              labelStyle: TextStyle(color: Colors.blueGrey),
              prefixIcon: Icon(Icons.lock),
              border: OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.green),
              ),
            ),
          ),
          const SizedBox(height: 20),
          AuthElevatedButton(
            text: 'Login',
            onPressed: () {
              String email = _emailController.text;
              String password = _passwordController.text;
              loginUser(email, password, context);
            },
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: () {
              context.push('/forgot_password');
            },
            child: Text(
              "Forgot Password?",
              style: TextStyle(
                color: Colors.blueGrey[700],
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline,
              ),
            ),

          ),
        ],
      ),
    );
  }
}
