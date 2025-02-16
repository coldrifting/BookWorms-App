import 'package:flutter/material.dart';

import 'package:bookworms_app/resources/colors.dart';
import 'package:bookworms_app/utils/widget_functions.dart';

class LoginRegisterWidget extends StatelessWidget {
  final VoidCallback onSignIn;
  final VoidCallback onSignUp;
  final bool signIn;

  const LoginRegisterWidget({
    required this.onSignIn,
    required this.onSignUp,
    required this.signIn,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _activeButton(signIn ? "SIGN IN" : "SIGN UP", signIn ? onSignIn : onSignUp),
        addVerticalSpace(12),
        Row(
          children: [
            const Expanded(
              child: Divider(
                thickness: 1,
                color: Colors.grey,
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                "or",
                style: TextStyle(color: Colors.grey),
              ),
            ),
            const Expanded(
              child: Divider(
                thickness: 1,
                color: Colors.grey,
              ),
            ),
          ],
        ),
        addVerticalSpace(12),
        _inactiveButton(signIn ? "SIGN UP" : "SIGN IN", signIn ? onSignUp : onSignIn),
      ],
    );
  }

  Widget _activeButton(String text, VoidCallback action) {
    return FractionallySizedBox(
      widthFactor: 1,
      child: ElevatedButton(
        onPressed: action,
        style: TextButton.styleFrom(
          backgroundColor: colorGreen,
          foregroundColor: colorWhite,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
        ),
        child: Text(text),
      ),
    );
  }

  Widget _inactiveButton(String text, VoidCallback action) {
    return FractionallySizedBox(
      widthFactor: 1,
      child: OutlinedButton(
        onPressed: action,
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: colorGrey),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
          foregroundColor: colorGrey,
        ),
        child: Text(text),
      ),
    );
  }
}