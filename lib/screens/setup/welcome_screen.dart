import 'package:bookworms_app/widgets/carousel_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:bookworms_app/screens/setup/login_screen.dart';
import 'package:bookworms_app/resources/theme.dart';
import 'package:bookworms_app/utils/widget_functions.dart';
import 'package:bookworms_app/screens/setup/register_screen.dart';

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
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Container(
          decoration: splashGradient(),
          child: SafeArea(
            child: Scaffold(
                backgroundColor: Colors.transparent,
                body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      CarouselWidget(),
                      addVerticalSpace(100),
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
                            onPressed: () {
                              pushScreen(context, const LoginScreen(), replace: true);
                            },
                            style: welcomeTextButtonStyle,
                            child: const Text("SIGN IN")
                          ),
                          addHorizontalSpace(32),
                          TextButton(
                            onPressed: () {
                              pushScreen(context, const RegisterScreen());
                            },
                            style: welcomeElevatedButtonStyle,
                            child: const Text("SIGN UP"),
                          ),
                        ],
                      ),
                      addVerticalSpace(64),
                    ],
                  ),
                )),
          ),
        ),
      ),
    );
  }
}
