import 'package:bookworms_app/main.dart';
import 'package:bookworms_app/utils/widget_functions.dart';
import 'package:flutter/material.dart';
import 'package:bookworms_app/services/account/login_service.dart';

/// The [LoginScreen] is where a user inputs their existing credentials to log into the app.
/// There is an alternative option to navigate to the [RegisterScreen].
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

/// The state of the [LoginScreen].
class _LoginScreenState extends State<LoginScreen> {

  final TextEditingController _usernameController = TextEditingController(); // Username text field
  final TextEditingController _passwordController = TextEditingController(); // Password text field

  final _formKey = GlobalKey<FormState>();

  Future<void> login(String username, String password) async {
    LoginService loginService = LoginService();

    // Attempt to log in the user with the provided credentials.
    await loginService.loginUser(username, password);
    if (mounted) {
      // Navigate to the home screen.
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const Navigation()),
      );
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Username text field
              TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter username'
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a username';
                  }
                  return null;
                },
              ),
              addVerticalSpace(16),
              // Password text field
              TextFormField(
                obscureText: true,
                controller: _passwordController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter password'
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a password';
                  }
                  return null;
                },
              ),
              addVerticalSpace(16),
              // "LOGIN" button
              TextButton(
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    final username = _usernameController.text;
                    final password = _passwordController.text;
                    login(username, password);
                  }
                },
                child: const Text('LOGIN'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}