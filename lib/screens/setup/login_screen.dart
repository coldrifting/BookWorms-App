import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:bookworms_app/app_state.dart';
import 'package:bookworms_app/main.dart';
import 'package:bookworms_app/screens/setup/register_screen.dart';
import 'package:bookworms_app/utils/widget_functions.dart';
import 'package:bookworms_app/widgets/login_register_widget.dart';
import 'package:bookworms_app/widgets/setup_backdrop_widget.dart';
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
  late TextEditingController _usernameController;
  late TextEditingController _passwordController;
  final _formKey = GlobalKey<FormState>();

  String loginError = "";

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Callback for when an error is recieved during sign in.
  // Sets the state of validation errors.
  void _handleValidationErrors(String error) {
    setState(() {
      loginError = error;
    });
  }


  // Attempts to log in the user.
  Future<void> login(String username, String password) async {
    LoginService loginService = LoginService();

    final bool status = await loginService.loginUser(username, password, _handleValidationErrors);
    if (status && mounted) {
      AppState appState = Provider.of<AppState>(context, listen: false);
      await appState.loadAccountDetails();
      await appState.loadAccountSpecifics();
      if (mounted) {
        // Navigate to the home screen.
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const Navigation()),
        );
      }
    }
  }

// The login screen is where a user inputs their existing credentials to log into the app.
// There is an alternative option to navigate to the register screen.
  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        child: SetupBackdropWidget(
          childWidget: SafeArea(child: _loginWidget(textTheme)),
        ),
      ),
    );
  }

  void attemptLogin() {
    if (_formKey.currentState?.validate() ?? false) {
      final username = _usernameController.text;
      final password = _passwordController.text;
      login(username, password);
    }
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
                  onFieldSubmitted: (value) => attemptLogin(),
                  decoration: const InputDecoration(labelText: 'Password'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a password';
                    }
                    return null;
                  },
                ),
                if (loginError.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      loginError,
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                addVerticalSpace(loginError.isEmpty ? 32 : 16),
                LoginRegisterWidget(
                    onSignIn: attemptLogin,
                    onSignUp: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const RegisterScreen()),
                      );
                    },
                    signIn: true),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
