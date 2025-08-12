import 'package:bookworms_app/resources/theme.dart';
import 'package:flutter/material.dart';

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
        _activeButton(context, signIn ? "SIGN IN" : "SIGN UP", signIn ? onSignIn : onSignUp),
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
        _inactiveButton(context, signIn ? "SIGN UP" : "SIGN IN", signIn ? onSignUp : onSignIn),
      ],
    );
  }

  Widget _activeButton(BuildContext context, String text, VoidCallback action) {
    return FractionallySizedBox(
      widthFactor: 1,
      child: ElevatedButton(
        onPressed: action,
        style: TextButton.styleFrom(
          backgroundColor: context.colors.primary,
          foregroundColor: context.colors.onPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
        ),
        child: Text(text),
      ),
    );
  }

  Widget _inactiveButton(BuildContext context, String text, VoidCallback action) {
    return FractionallySizedBox(
      widthFactor: 1,
      child: OutlinedButton(
        onPressed: action,
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: context.colors.grey),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
          foregroundColor: context.colors.grey,
        ),
        child: Text(text),
      ),
    );
  }
}