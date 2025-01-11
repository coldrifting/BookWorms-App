import 'package:bookworms_app/screens/setup/login_screen.dart';
import 'package:bookworms_app/theme/colors.dart';
import 'package:bookworms_app/theme/theme.dart';
import 'package:flutter/material.dart';

/// The [WelcomeScreen] is what the user sees after the splash screen if they are
/// not already logged in. It provides the option to either "login" or "register".
class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

/// The state of the [WelcomeScreen].
class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return Scaffold(
      body: Container(
        color: colorGreen,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                "BookWorms",
                style: themeData.textTheme.headlineLargeWhite,
              ),
              Text(
                "Discover stories that inspire.\nStart exploring today!",
                textAlign: TextAlign.center,
                style: themeData.textTheme.bodyLargeWhite,
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () => {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const LoginScreen()),
                      )
                    }, 
                    style: TextButton.styleFrom(
                      foregroundColor: colorWhite,
                    ),
                    child: const Text(
                      "LOGIN",
                      )
                  ),
                  const SizedBox(width: 32),
                  TextButton(
                    onPressed: () => {}, 
                    style: TextButton.styleFrom(
                      backgroundColor: colorWhite,
                    ),
                    child: const Text(
                      "SIGNUP",
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 64),
          ],),
        ),
      )
    );
  }
}