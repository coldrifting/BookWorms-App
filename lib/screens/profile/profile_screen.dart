import 'package:bookworms_app/screens/profile/about_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:bookworms_app/app_state.dart';
import 'package:bookworms_app/screens/profile/edit_profile_screen.dart';
import 'package:bookworms_app/screens/profile/manage_children_screen.dart';
import 'package:bookworms_app/screens/setup/welcome_screen.dart';
import 'package:bookworms_app/services/auth_storage.dart';
import 'package:bookworms_app/utils/user_icons.dart';
import 'package:bookworms_app/resources/colors.dart';
import 'package:bookworms_app/utils/widget_functions.dart';
import 'package:bookworms_app/widgets/extended_appbar_widget.dart';
import 'package:bookworms_app/widgets/option_widget.dart';

/// The [ProfileScreen] displays relevant settings options for the user account.
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

/// The state of the [ProfileScreen].
class _ProfileScreenState extends State<ProfileScreen> {
  void signOut() async {
    deleteToken();
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.remove('recentBookIds');
    if (mounted) {
      pushScreen(context, const WelcomeScreen(), replace: true, root: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    AppState appState = Provider.of<AppState>(context);
    var isParent = appState.isParent;

    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: defaultOverlay(),
        title: Text("${isParent ? "Parent" : "Teacher"} Profile",
            style: const TextStyle(color: colorWhite)),
        centerTitle: true,
        backgroundColor: colorGreen,
      ),
      body: Column(
        children: [
          ExtendedAppBar(
            name: "${appState.firstName} ${appState.lastName}",
            username: appState.username,
            icon: UserIcons.getIcon(appState.account.profilePictureIndex),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                addVerticalSpace(10),
                OptionWidget(
                    name: "Edit Profile",
                    icon: Icons.account_circle,
                    onTap: () {
                      pushScreen(context, EditProfileScreen(account: appState.account));
                    }),
                addVerticalSpace(10),
                if (isParent) ...[
                  OptionWidget(
                      name: "Manage Children",
                      icon: Icons.groups_rounded,
                      onTap: () {
                        pushScreen(context, const ManageChildrenScreen());
                      }),
                  addVerticalSpace(10),
                ],
                OptionWidget(
                  name: "About",
                  icon: Icons.settings,
                  onTap: () {
                    pushScreen(context, const AboutScreen());
                  },
                ),
                addVerticalSpace(10),
                const Divider(),
                addVerticalSpace(10),
                _signOutWidget()
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _signOutWidget() {
    return ElevatedButton(
      onPressed: signOut,
      style: ElevatedButton.styleFrom(
        foregroundColor: colorBlack,
        backgroundColor: colorWhite,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
        side: BorderSide(color: colorGreyDark),
        padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(size: 32, Icons.logout_outlined),
          addHorizontalSpace(8),
          Text(
            "Sign Out",
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold
            )
          ),
        ],
      )
    );
  }
}
