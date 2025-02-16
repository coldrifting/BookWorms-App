import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:bookworms_app/app_state.dart';
import 'package:bookworms_app/main.dart';
import 'package:bookworms_app/screens/setup/add_first_child.dart';
import 'package:bookworms_app/screens/setup/login_screen.dart';
import 'package:bookworms_app/services/account/register_service.dart';
import 'package:bookworms_app/resources/colors.dart';
import 'package:bookworms_app/utils/widget_functions.dart';
import 'package:bookworms_app/widgets/login_register_widget.dart';
import 'package:bookworms_app/widgets/setup_backdrop_widget.dart';

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
  final _formKey = GlobalKey<FormState>();

  Map<String, String> fieldErrors = {};
  bool _isParent = true;

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

  // Set the state of validation errors if received when registering.
  void _handleValidationErrors(Map<String, String> errors) {
    setState(() {
      fieldErrors = errors;
    });
  }

  Future<void> register(String username, String password, String firstName, String lastName, bool isParent) async {
    RegisterService registerService = RegisterService();

    bool status = await registerService.registerUser(username, password, firstName, lastName, isParent, _handleValidationErrors);
    if (status && mounted) {
      AppState appState = Provider.of<AppState>(context, listen: false);
      await appState.loadAccountDetails();
      if (mounted) {
        if (isParent)
        {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const AddFirstChild()),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const Navigation()),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        child: SetupBackdropWidget(
          childWidget: SafeArea(child: _createAccountWidget(textTheme)),
        ),
      ),
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
                  decoration: InputDecoration(
                    labelText: 'Username',
                    errorText: fieldErrors["Username"],
                  ),
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
                  decoration: InputDecoration(
                    labelText: 'Password',
                    errorText: fieldErrors["Password"],
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a password';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _firstNameController,
                  decoration: InputDecoration(
                    labelText: 'First Name',
                    errorText: fieldErrors["FirstName"],
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your first name';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _lastNameController,
                  decoration: InputDecoration(
                    labelText: 'Last Name',
                    errorText: fieldErrors["LastName"],
                  ),
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
                addVerticalSpace(32),
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
                addVerticalSpace(32),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
