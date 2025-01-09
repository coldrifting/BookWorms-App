import 'package:bookworms_app/screens/home/home_screen.dart';
import 'package:bookworms_app/utils/constants.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: COLOR_GREEN,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const Text(
                "BookWorms",
                style: TextStyle(color: COLOR_WHITE, fontSize: 28),
              ),
              const Text(
                "Discover stories that inspire.\nStart exploring today!",
                textAlign: TextAlign.center,
                style: TextStyle(color: COLOR_WHITE, fontSize: 14),
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () => {
                      Navigator.pushReplacement( // Come back to this! Without stack?
                        context,
                        MaterialPageRoute(builder: (_) => const HomeScreen()),
                      )
                    }, 
                    style: TextButton.styleFrom(
                      foregroundColor: COLOR_WHITE,
                    ),
                    child: const Text(
                      "LOGIN",
                      )
                  ),
                  const SizedBox(width: 32),
                  TextButton(
                    onPressed: () => {}, 
                    style: TextButton.styleFrom(
                      backgroundColor: COLOR_WHITE,
                    ),
                    child: const Text(
                      "SIGNUP",
                      )
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