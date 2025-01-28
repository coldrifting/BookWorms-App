import 'package:bookworms_app/app_state.dart';
import 'package:bookworms_app/main.dart';
import 'package:bookworms_app/screens/setup/login_screen.dart';
import 'package:bookworms_app/services/account/register_service.dart';
import 'package:bookworms_app/theme/colors.dart';
import 'package:bookworms_app/utils/widget_functions.dart';
import 'package:bookworms_app/widgets/login_register_widget.dart';
import 'package:bookworms_app/widgets/setup_backdrop_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  late TextEditingController _usernameController;
  late TextEditingController _passwordController;
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  bool _isParent = true;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController();
    _passwordController = TextEditingController();
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  Future<void> register(String username, String password, String firstName,
      String lastName, bool isParent) async {
    RegisterService registerService = RegisterService();
    await registerService.registerUser(
        username, password, firstName, lastName, isParent);
    if (mounted) {
      AppState appState = Provider.of<AppState>(context, listen: false);
      await appState.loadAccount();
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const Navigation()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return SafeArea(
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: SetupBackdropWidget(childWidget: _createAccountWidget(textTheme))),
    );
  }

  Widget _createAccountWidget(TextTheme textTheme) {
    return Column(
      children: [
        Text(
          "Create an Account",
          style: textTheme.headlineLarge,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
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
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: 'Password'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a password';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _firstNameController,
                  decoration: const InputDecoration(labelText: 'First Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your first name';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _lastNameController,
                  decoration: const InputDecoration(labelText: 'Last Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your last name';
                    }
                    return null;
                  },
                ),
                addVerticalSpace(16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Account Type",
                      style: TextStyle(color: Colors.grey[700], fontSize: 16),
                    ),
                    Spacer(),
                    ChoiceChip(
                      label: const Text('Parent'),
                      selected: _isParent,
                      selectedColor: colorGreenLight,
                      onSelected: (selected) {
                        setState(() {
                          _isParent = true;
                        });
                      },
                    ),
                    const SizedBox(width: 16),
                    ChoiceChip(
                      label: const Text('Teacher'),
                      selected: !_isParent,
                      selectedColor: colorGreenLight,
                      onSelected: (selected) {
                        setState(() {
                          _isParent = false;
                        });
                      },
                    ),
                  ],
                ),
                addVerticalSpace(16),
                LoginRegisterWidget(
                  onSignUp: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      final username = _usernameController.text;
                      final password = _passwordController.text;
                      final firstName = _firstNameController.text;
                      final lastName = _lastNameController.text;
                      register(username, password, firstName, lastName, _isParent);
                    }
                  },
                  onSignIn: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginScreen()),
                    );
                  }, 
                  signIn: false
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
