import 'package:bookworms_app/app_state.dart';
import 'package:bookworms_app/main.dart';
import 'package:bookworms_app/screens/setup/register_screen.dart';
import 'package:bookworms_app/utils/widget_functions.dart';
import 'package:bookworms_app/widgets/login_register_widget.dart';
import 'package:bookworms_app/widgets/setup_backdrop_widget.dart';
import 'package:flutter/material.dart';
import 'package:bookworms_app/services/account/login_service.dart';
import 'package:provider/provider.dart';

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
      AppState appState = Provider.of<AppState>(context, listen: false);
      await appState.loadAccount();
      if (mounted) {
        // Navigate to the home screen.
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const Navigation()),
        );
      }
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
    final TextTheme textTheme = Theme.of(context).textTheme;
    return SafeArea(
      child: Scaffold(
        body: SetupBackdropWidget(childWidget: _loginWidget(textTheme)),
      ),
    );
  }

  Widget _loginWidget(TextTheme textTheme) {
    return Column(
      children: [
        Text(
          "Sign In",
          style: textTheme.headlineLarge,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Username text field
                TextFormField(
                  controller: _usernameController,
                  decoration: const InputDecoration(labelText: 'Username'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a username';
                    }
                    return null;
                  },
                ),
                // Password text field
                TextFormField(
                  obscureText: true,
                  controller: _passwordController,
                  decoration: const InputDecoration(labelText: 'Password'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a password';
                    }
                    return null;
                  },
                ),
                addVerticalSpace(32),
                LoginRegisterWidget(
                  onSignIn: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      final username = _usernameController.text;
                      final password = _passwordController.text;
                      login(username, password);
                    }
                  },
                  onSignUp: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const RegisterScreen()),
                    );
                  }, 
                  signIn: true
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}