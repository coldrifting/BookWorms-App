import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:bookworms_app/resources/colors.dart';
import 'package:bookworms_app/utils/user_icons.dart';
import 'package:bookworms_app/widgets/extended_appbar_widget.dart';
import 'package:bookworms_app/utils/widget_functions.dart';

class StudentViewScreen extends StatefulWidget {
  const StudentViewScreen({super.key, });

  @override
  State<StudentViewScreen> createState() => _StudentViewScreenState();
}

var x = SystemUiOverlayStyle(
  // Status bar color
  statusBarColor: Colors.red,

  // Status bar brightness (optional)
  statusBarIconBrightness: Brightness.dark, // For Android (dark icons)
  statusBarBrightness: Brightness.light, // For iOS (dark icons)
);

class _StudentViewScreenState extends State<StudentViewScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: defaultOverlay(),
        title: const Text("",
            style: TextStyle(
                fontWeight: FontWeight.normal,
                color: colorWhite,
                overflow: TextOverflow.ellipsis)),
        backgroundColor: colorGreen,
        leading: IconButton(
          color: colorWhite,
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Center(
        child: Column(
          children: [
            ExtendedAppBar(
              name: "Student",
              username: "student",
              icon: UserIcons.getIcon(UserIcons.getRandomIconIndex())
            ),
          ],
        ),
      ),
    );
  }
}
