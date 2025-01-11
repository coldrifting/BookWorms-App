import 'package:bookworms_app/icons/user_icons.dart';
import 'package:bookworms_app/utils/constants.dart';
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
  @override
  Widget build(BuildContext context) {  
    return Scaffold(
      appBar: AppBar(
        title: const Text("Parent Profile", style: TextStyle(color: colorWhite)),
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
                const Text(
                  style: TextStyle(color: colorWhite, fontSize: 20),
                  "Audrey Hepburn"
                ),
                const Text(
                  style: TextStyle(color: colorWhite, fontSize: 14),
                  "@AudHep"
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: [
                SizedBox(height: 10),
                OptionWidget(name: "Edit Profile", icon: Icons.account_circle),
                SizedBox(height: 10),
                OptionWidget(name: "Manage Children", icon: Icons.groups_rounded),
                SizedBox(height: 10),
                OptionWidget(name: "Settings", icon: Icons.settings),
                SizedBox(height: 10),
                Divider(),
                SizedBox(height: 10),
                OptionWidget(name: "Log Out", icon: Icons.logout_outlined),
              ],
            ),
          ),
        ],
      ),
    );
  }
}