import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:bookworms_app/screens/setup/login_screen.dart';
import 'package:bookworms_app/resources/colors.dart';
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
          decoration: _gradient(),
          child: SafeArea(
            child: Scaffold(
                backgroundColor: Colors.transparent,
                body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      _carousel(textTheme),
                      addVerticalSpace(128),
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
                                MaterialPageRoute(
                                  builder: (_) => const LoginScreen()
                                ),
                              )
                            },
                            style: TextButton.styleFrom(
                              foregroundColor: colorWhite,
                            ),
                            child: const Text("SIGN IN")
                          ),
                          addHorizontalSpace(32),
                          TextButton(
                            onPressed: () => {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const RegisterScreen()
                                ),
                              )
                            },
                            style: TextButton.styleFrom(
                              backgroundColor: colorWhite,
                            ),
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

  BoxDecoration _gradient() {
    return const BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment(0.8, 1),
        colors: <Color>[
          colorGreenGradTop,
          colorGreenGradBottom,
        ],
      ),
    );
  }

  Widget _carousel(TextTheme textTheme) {
    final carouselImages = [
      'assets/images/welcome_1.jpg',
      'assets/images/welcome_2.jpg',
      'assets/images/welcome_3.jpg',
      'assets/images/welcome_4.jpg',
    ];
    final carouselText = [
      "Find the perfect books for your child",
      "Create and fill custom bookshelves",
      "Assign and track reading goals",
      "Join and manage virtual classrooms",
    ];

    return CarouselSlider.builder(
      itemCount: carouselImages.length,
      itemBuilder: (context, index, realIndex) {
        return Column(
          children: [
            Expanded(
              child: Image.asset(
                carouselImages[index],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              carouselText[index],
              style: textTheme.bodyLargeWhite,
              textAlign: TextAlign.center,
            ),
          ],
        );
      },
      options: CarouselOptions(
        autoPlay: true,
        enlargeCenterPage: true,
      ),
    );
  }
}
