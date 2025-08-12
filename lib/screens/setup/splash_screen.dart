import 'package:bookworms_app/main.dart';
import 'package:bookworms_app/resources/theme.dart';
import 'package:bookworms_app/screens/setup/connection_error_screen.dart';
import 'package:bookworms_app/services/account/ping_service.dart';
import 'package:bookworms_app/utils/widget_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bookworms_app/app_state.dart';
import 'package:bookworms_app/screens/setup/add_first_child.dart';
import 'package:bookworms_app/screens/setup/welcome_screen.dart';
import 'package:bookworms_app/services/auth_storage.dart';
import 'package:bookworms_app/services/status_code_exceptions.dart';

/// The [SplashScreen] displays an animation while user data is initialized.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

/// The state of the [SplashScreen]
class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkServerUrlAndToken();
  }

  // The splash Screen displays an animation while user data is initialized.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: AnnotatedRegion<SystemUiOverlayStyle>(
            value: SystemUiOverlayStyle.light,
            child: Container(
                decoration: splashGradient(),
                child: Center(
                    child: CircularProgressIndicator(color: context.colors.onPrimary)))));
  }

  // Attempts to fetch a JWT from secure storage.
  // If the JWT is valid, the user is allowed into the app.
  // If the JWT is invalid, the user must log in or register for an account.
  Future<void> _checkServerUrlAndToken() async {
    PingService pingService = PingService();
    final results = await Future.wait([pingService.ping(), getToken()]);

    if (!mounted) {
      return;
    }

    // Check ping results
    bool? isServerUrlValid = results[0] as bool?;
    if (isServerUrlValid != true) {
      pushScreen(context, const ConnectionErrorScreen(), replace: true);
      return;
    }

    String? token = results[1] as String?;
    if (token == null) {
      goToWelcomeScreen(context);
      return;
    }

    AppState appState = Provider.of<AppState>(context, listen: false);
    try {
      await appState.loadAccountDetails();
      await appState.loadAccountSpecifics();
    } on UnauthorizedException {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      await preferences.remove('recentBookIds');

      if (mounted) {
        goToWelcomeScreen(context);
      }
      return;
    }
    if (mounted) {
      // If a user with a parent account opens the app while a JWT has been saved but no child profiles exist.
      // This will occur if the user exits the app immediately after registration.
      if (appState.isParent && appState.children.isEmpty) {
        pushScreen(context, const AddFirstChild(), replace: true);
      } else {
        pushScreen(context, const Navigation(), replace: true);
      }
    }
  }

  void goToWelcomeScreen(BuildContext context) {
    if (context.mounted) {
      FocusManager.instance.primaryFocus?.unfocus();
      pushScreen(context, const WelcomeScreen(), replace: true);
    }
  }
}
