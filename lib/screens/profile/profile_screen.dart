import 'package:bookworms_app/app_state.dart';
import 'package:bookworms_app/main.dart';
import 'package:bookworms_app/screens/profile/edit_profile_screen.dart';
import 'package:bookworms_app/screens/profile/manage_children_screen.dart';
import 'package:bookworms_app/screens/setup/welcome_screen.dart';
import 'package:bookworms_app/services/auth_storage.dart';
import 'package:bookworms_app/utils/user_icons.dart';
import 'package:bookworms_app/theme/colors.dart';
import 'package:bookworms_app/utils/widget_functions.dart';
import 'package:bookworms_app/widgets/extended_appbar_widget.dart';
import 'package:bookworms_app/widgets/option_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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

    AppState appState =  Provider.of<AppState>(context);
    var isParent = appState.isParent;

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
            ExtendedAppBar(
              name: "${appState.firstName} ${appState.lastName}", 
              username: appState.username,
              icon: UserIcons.getIcon(0),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  addVerticalSpace(10),
                  OptionWidget(
                    name: "Edit Profile", 
                    icon: Icons.account_circle, 
                    onTap: () {
                      pushScreen(context, EditProfileScreen());
                    }
                  ),
                  addVerticalSpace(10),
                  if (isParent) ...[
                    OptionWidget(
                      name: "Manage Children", 
                      icon: Icons.groups_rounded, 
                      onTap: () {
                        pushScreen(context, const ManageChildrenScreen());
                      }
                    ),
                    addVerticalSpace(10),
                  ],
                  OptionWidget(
                    name: "Settings", 
                    icon: Icons.settings, 
                    onTap: () {},
                  ),
                  addVerticalSpace(10),
                  const Divider(),
                  addVerticalSpace(10),
                  OptionWidget(
                    name: "Sign Out", 
                    icon: Icons.logout_outlined, 
                    onTap: () {
                      signOut();
                    },
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