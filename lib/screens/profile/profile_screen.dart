import 'package:bookworms_app/main.dart';
import 'package:bookworms_app/screens/profile/manage_children_screen.dart';
import 'package:bookworms_app/screens/setup/welcome_screen.dart';
import 'package:bookworms_app/services/auth_storage.dart';
import 'package:bookworms_app/theme/theme.dart';
import 'package:bookworms_app/utils/user_icons.dart';
import 'package:bookworms_app/theme/colors.dart';
import 'package:bookworms_app/utils/widget_functions.dart';
import 'package:bookworms_app/widgets/option_widget.dart';
import 'package:flutter/material.dart';

/// The [ProfileScreen] displays relevant settings options for the user account.
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

/// The state of the [ProfileScreen].
class _ProfileScreenState extends State<ProfileScreen> {

  Future<void> signOut() async {
    await deleteToken();
    navigatorKey.currentState?.pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const WelcomeScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    var isParent = false; // Temporary until role is implemented.

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "${isParent ? "Parent" : "Teacher"} Profile", 
            style: const TextStyle(color: colorWhite)
          ),
          centerTitle: true,
          backgroundColor: colorGreen,
        ),
        body: Column(
          children: [
            Container(
              height: 180,
              width: double.infinity,
              decoration: BoxDecoration(
                color: colorGreen,
                boxShadow: [
                  BoxShadow(
                    color: colorBlack.withOpacity(0.4),
                    spreadRadius: 1,
                    blurRadius: 4,
                    offset: const Offset(0, 3),
                  ),
                ],
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 120,
                    height: 120,
                    child: UserIcons.getIcon("")
                  ),
                  Text(
                    style: textTheme.titleLargeWhite,
                    "Audrey Hepburn"
                  ),
                  Text(
                    style: textTheme.bodyLargeWhite,
                    "@AudHep"
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  addVerticalSpace(10),
                  const OptionWidget(name: "Edit Profile", icon: Icons.account_circle),
                  addVerticalSpace(10),
                  if (isParent) ...[
                    ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ManageChildrenScreen()
                      )
                    );
                  },
                  icon: const Icon(Icons.groups_rounded),
                      label: const Text('Manage Children'),
                ),
                addVerticalSpace(10),
                  ],
                  const OptionWidget(name: "Settings", icon: Icons.settings),
                  addVerticalSpace(10),
                  const Divider(),
                  addVerticalSpace(10),
                  ElevatedButton.icon(
                    onPressed: () {
                      signOut();
                    },
                    icon: const Icon(Icons.logout_outlined),
                    label: const Text('Sign Out'),
                  ),
                      ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}