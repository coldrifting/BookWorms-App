import 'package:bookworms_app/app_state.dart';
import 'package:bookworms_app/main.dart';
import 'package:bookworms_app/theme/colors.dart';
import 'package:bookworms_app/theme/theme.dart';
import 'package:bookworms_app/utils/widget_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

/// The [SelectRoleScreen] contains...
class SelectRoleScreen extends StatefulWidget {
  const SelectRoleScreen({super.key});

  @override
  State<SelectRoleScreen> createState() => _SelectRoleScreenState();
}

/// The state of the [SelectRoleScreen].
class _SelectRoleScreenState extends State<SelectRoleScreen> {
  List<String> roles = ["Parent", "Teacher"];

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return SafeArea(
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.topCenter,
              children: [
                SizedBox(
                  height: 155,
                  child: SvgPicture.asset(
                    'assets/images/setup_curve_top.svg',
                  ),
                ),
                SizedBox(
                  height: 200,
                  child: SvgPicture.asset(
                    'assets/images/bookworms_logo.svg',
                    width: 125,
                    semanticsLabel: "BookWorms Logo",
                  ),
                ),
              ],
            ),
            const Spacer(),
            Text(
              "Select Role", 
              style: textTheme.headlineLarge,
            ),
            addVerticalSpace(32),
            ... roles.expand((role) {
              return [
                FractionallySizedBox(
                  widthFactor: 0.8,
                  child: SizedBox(
                    height: 100,
                    child: TextButton(
                      onPressed: () => _setRole(role), 
                      style: TextButton.styleFrom(
                        backgroundColor: colorGreenDark,
                        foregroundColor: colorWhite,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: Text(
                        role,
                        style: textTheme.headlineLargeWhite
                      ),
                    ),
                  ),
                ),
                addVerticalSpace(32),
              ];
            }).toList(),
            const Spacer(),
            SizedBox(
              height: 155,
              child: SvgPicture.asset(
                'assets/images/setup_curve_bottom.svg',
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _setRole(String role) {
    // TO DO: Set the account role
    Provider.of<AppState>(context, listen: false).setRole(role);

    // Once role is set, navigate to the home screen.
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const Navigation()),
      );
    }
  }
}