import 'package:bookworms_app/resources/theme.dart';
import 'package:bookworms_app/utils/user_icons.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:bookworms_app/app_state.dart';
import 'package:bookworms_app/main.dart';
import 'package:bookworms_app/screens/setup/add_first_child.dart';
import 'package:bookworms_app/screens/setup/login_screen.dart';
import 'package:bookworms_app/services/account/register_service.dart';
import 'package:bookworms_app/utils/widget_functions.dart';
import 'package:bookworms_app/widgets/login_register_widget.dart';
import 'package:bookworms_app/widgets/setup_backdrop_widget.dart';


/// The [RegisterScreen] is where a user inputs their credentials to create an account.
/// There is an alternative option to navigate to the [LoginScreen].
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

/// The state of the [RegisterScreen].
class _RegisterScreenState extends State<RegisterScreen> {
  late TextEditingController _usernameController;
  late TextEditingController _passwordController;
  late TextEditingController _confirmPasswordController;
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
    _confirmPasswordController = TextEditingController();
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  // Callback for when an error is recieved during registration.
  // Sets the state of the validation errors.
  void _handleValidationErrors(Map<String, String> errors) {
    setState(() {
      fieldErrors = errors;
    });
  }

  // Attempts to register the user.
  Future<void> register(String username, String password, String firstName, String lastName, bool isParent) async {
    RegisterService registerService = RegisterService();

    bool status = await registerService.registerUser(username, password, firstName, lastName, isParent, _handleValidationErrors);
    if (status && mounted) {
      AppState appState = Provider.of<AppState>(context, listen: false);
      await appState.loadAccountDetails();
      if (mounted) {
        if (isParent) {
          pushScreen(context, const AddFirstChild(), replace: true);
        } else {
          pushScreen(context, const Navigation(), replace: true);
        }
        appState.account.profilePictureIndex = UserIcons.getRandomIconIndex();
      }
    }
  }

// The register screen is where a user inputs their credentials to create an account.
// There is an alternative option to navigate to the login screen.
  @override
  Widget build(BuildContext context) {
    return SetupBackdropWidget(childWidget: _createAccountWidget());
  }

  // Sub-widget containing text forms for providing account information.
  Widget _createAccountWidget() {
    final TextTheme textTheme = Theme.of(context).textTheme;
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
                // Username text field
                TextFormField(
                  controller: _usernameController,
                  textInputAction: TextInputAction.next,
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
                Row(
                  children: [
                    // Password text field
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 2 - 40,
                      child: TextFormField(
                        controller: _passwordController,
                        textInputAction: TextInputAction.next,
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
                      )
                    ),
                    addHorizontalSpace(16),
                    // Confirm password text field
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 2 - 40,
                      child: TextFormField(
                        controller: _confirmPasswordController,
                        textInputAction: TextInputAction.next,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'Confirm Password',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please confirm your password';
                          }
                          if (value != _passwordController.text) {
                            return 'Passwords do not match';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                // Confirm password text field
                // First name text field
                Row(
                  children: [

                SizedBox(
                  width: MediaQuery.of(context).size.width / 2 - 40,
                  child: TextFormField(
                    controller: _firstNameController,
                    textInputAction: TextInputAction.next,
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
                ),
                addHorizontalSpace(16),
                // Last name text field
                SizedBox(
                  width: MediaQuery.of(context).size.width / 2 - 40,
                  child: TextFormField(
                    controller: _lastNameController,
                    textInputAction: TextInputAction.go,
                    onFieldSubmitted: (_) => validateRegister(),
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
                ),
                  ]
                ),
                addVerticalSpace(16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Account Type",
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 16
                      ),
                    ),
                    Spacer(),
                    ChoiceChip(
                      label: const Text('Parent'),
                      selected: _isParent,
                      selectedColor: context.colors.secondary,
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
                      selectedColor: context.colors.secondary,
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
                    validateRegister();
                  },
                  onSignIn: () {
                    pushScreen(context, const LoginScreen(), replace: true);
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

  void validateRegister() {
    if (_formKey.currentState?.validate() ?? false) {
      final username = _usernameController.text;
      final password = _passwordController.text;
      final firstName = _firstNameController.text;
      final lastName = _lastNameController.text;
      register(username, password, firstName, lastName, _isParent);
    }
  }
}
