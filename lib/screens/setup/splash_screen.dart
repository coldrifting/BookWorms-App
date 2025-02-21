import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:bookworms_app/app_state.dart';
import 'package:bookworms_app/screens/bookshelves/bookshelves_screen.dart';
import 'package:bookworms_app/screens/classroom/classroom_screen.dart';
import 'package:bookworms_app/screens/home_screen.dart';
import 'package:bookworms_app/screens/profile/profile_screen.dart';
import 'package:bookworms_app/screens/progress_screen.dart';
import 'package:bookworms_app/screens/setup/add_first_child.dart';
import 'package:bookworms_app/screens/setup/welcome_screen.dart';
import 'package:bookworms_app/services/auth_storage.dart';
import 'package:bookworms_app/services/status_code_exceptions.dart';
import 'package:bookworms_app/resources/colors.dart';
import 'package:bookworms_app/resources/theme.dart';
import 'package:bookworms_app/screens/search/search_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _tokenNavigate();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }

  Future<void> _tokenNavigate() async {
    final splashDelay = Future.delayed(const Duration(seconds: 2));
    var token = getToken();
    final results = await Future.wait([splashDelay, token]);
    
    if (mounted) {
      if (results[1] != null) {
        AppState appState = Provider.of<AppState>(context, listen: false);
        try {
          await appState.loadAccountDetails();
          await appState.loadAccountSpecifics();
        } on UnauthorizedException {
          deleteToken();
          SharedPreferences preferences = await SharedPreferences.getInstance();
          await preferences.remove('recentBookIds');
          if (mounted) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const WelcomeScreen()),
            );
          }
          return;
        } 
        if (mounted) {
          // If a user with a parent account opens the app while a JWT has been saved but no child profiles exist.
          // This will occur if the user exits the app immediately after registration.
          if (appState.isParent && appState.children.isEmpty) {
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
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const WelcomeScreen()),
        );
      }
    }
  }
}