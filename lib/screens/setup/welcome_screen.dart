import 'package:bookworms_app/screens/setup/login_screen.dart';
import 'package:bookworms_app/theme/colors.dart';
import 'package:bookworms_app/theme/theme.dart';
import 'package:bookworms_app/utils/widget_functions.dart';
import 'package:flutter/material.dart';

import 'register_screen.dart';

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
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Scaffold(
      body: Container(
        decoration: _gradient(),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                "BookWorms",
                style: textTheme.displaySmallWhite,
              ),
              Text(
                "Discover stories that inspire.\nStart exploring today!",
                textAlign: TextAlign.center,
                style: textTheme.bodyLargeWhite,
              ),
              addVerticalSpace(32),
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
                  addHorizontalSpace(32),
                  TextButton(
                    onPressed: () => {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const RegisterScreen()),
                      )
                    }, 
                    style: TextButton.styleFrom(
                      backgroundColor: colorWhite,
                    ),
                    child: const Text(
                      "SIGNUP",
                    ),
                  ),
                ],
              ),
              addVerticalSpace(64),
          ],),
        ),
      )
    );
  }

  BoxDecoration _gradient() {
    return const BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment(0.8, 1),
        colors: <Color>[
          Color(0xff1f005c),
          Color(0xff5b0060),
          Color(0xff870160),
          Color(0xffac255e),
          Color(0xffca485c),
          Color(0xffe16b5c),
          Color(0xfff39060),
          Color(0xffffb56b),
        ],
      ),
    );
  }
}