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

  late LoginService _loginService;

  @override
  void initState() {
    super.initState();
    _loginService = LoginService();
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Username text field
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter username'
              ),
            ),
            addVerticalSpace(16),
            // Password text field
            TextField(
              obscureText: true,
              controller: _passwordController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter password'
              ),
            ),
            addVerticalSpace(16),
            // "LOGIN" button
            TextButton(
              onPressed: () {
                setState(() {
                  // Attempt to log in the user with the provided credentials.
                  _loginService.loginUser(_usernameController.text, _passwordController.text);
        
                  // Navigate to the home screen.
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const Navigation()),
                  );
                });
              },
              child: const Text('LOGIN'),
            ),
          ],
        ),
      ),
    );
  }
}