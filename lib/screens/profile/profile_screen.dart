import 'package:bookworms_app/app_state.dart';
import 'package:bookworms_app/resources/theme.dart';
import 'package:bookworms_app/screens/profile/about_screen.dart';
import 'package:bookworms_app/screens/profile/edit_profile_screen.dart';
import 'package:bookworms_app/screens/profile/manage_children_screen.dart';
import 'package:bookworms_app/screens/setup/welcome_screen.dart';
import 'package:bookworms_app/services/auth_storage.dart';
import 'package:bookworms_app/showcase/showcase_controller.dart';
import 'package:bookworms_app/showcase/showcase_widgets.dart';
import 'package:bookworms_app/utils/user_icons.dart';
import 'package:bookworms_app/utils/widget_functions.dart';
import 'package:bookworms_app/widgets/app_bar_custom.dart';
import 'package:bookworms_app/widgets/extended_appbar_widget.dart';
import 'package:bookworms_app/widgets/option_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:showcaseview/showcaseview.dart';

/// The [ProfileScreen] displays relevant settings options for the user account.
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

/// The state of the [ProfileScreen].
class _ProfileScreenState extends State<ProfileScreen> {
  late final showcaseController = ShowcaseController();
  late final List<GlobalKey> navKeys = showcaseController.getKeysForScreen('profile');

  void signOut() async {
    deleteToken();
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.remove('recentBookIds');
    showcaseController.reset();
    if (mounted) {
      pushScreen(context, const WelcomeScreen(), replace: true, root: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    AppState appState = Provider.of<AppState>(context);
    var isParent = appState.isParent;

    String headerTitle = "${isParent ? "Parent" : "Teacher"} Profile";

    return Scaffold(
      appBar: AppBarCustom(headerTitle, isLeafPage: false, centerTitle: true),
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
                BWShowcase(
                  showcaseKey: navKeys[0],
                  description: "Edit your account details",
                  tooltipBorderRadius: BorderRadius.circular(6),
                  child: OptionWidget(
                      name: "Edit Profile",
                      icon: Icons.account_circle,
                      onTap: () {
                        pushScreen(context, EditProfileScreen(account: appState.account));
                      }),
                ),
                addVerticalSpace(10),
                if (isParent) ...[
                  BWShowcase(
                    showcaseKey: navKeys[1],
                    description: "Manage your children, including adding them to classrooms",
                    tooltipBorderRadius: BorderRadius.circular(6),
                    child: OptionWidget(
                        name: "Manage Children",
                        icon: Icons.groups_rounded,
                        onTap: () {
                          pushScreen(context, const ManageChildrenScreen());
                        }),
                  ),
                  addVerticalSpace(10),
                ],
                OptionWidget(
                  name: "About",
                  icon: Icons.info,
                  onTap: () => pushScreen(context, const AboutScreen()),
                ),
                addVerticalSpace(10),
                BWShowcase(
                  showcaseKey: isParent ? navKeys[2] : navKeys[1],
                  description: "View this tutorial again",
                  tooltipBorderRadius: BorderRadius.circular(6),
                  tooltipPosition: TooltipPosition.top,
                  child: OptionWidget(
                      name: "Tutorial",
                      icon: Icons.help,
                      onTap:() {
                        showcaseController.goToScreen(0);
                        showcaseController.start();
                      }
                  ),
                ),
                addVerticalSpace(10),
                const Divider(),
                addVerticalSpace(10),
                _signOutWidget(textTheme)
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _signOutWidget(TextTheme textTheme) {
    return ElevatedButton(
      onPressed: signOut,
      style: getCommonButtonStyle(primaryColor: context.colors.primaryVariant),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(size: 32, Icons.logout_outlined),
          addHorizontalSpace(8),
          Text("Sign Out", style: TextStyle(fontSize: 18)),
        ],
      )
    );
  }
}
