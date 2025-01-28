import 'package:bookworms_app/theme/colors.dart';
import 'package:bookworms_app/utils/user_icons.dart';
import 'package:bookworms_app/widgets/extended_appbar_widget.dart';
import 'package:flutter/material.dart';

class StudentViewScreen extends StatefulWidget {
  const StudentViewScreen({super.key});

  @override
  State<StudentViewScreen> createState() => _StudentViewScreenState();
}

class _StudentViewScreenState extends State<StudentViewScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
            title: const Text(
              "", 
              style: TextStyle(
                fontWeight: FontWeight.normal,
                color: colorWhite, 
                overflow: TextOverflow.ellipsis
              )
            ),
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
              ExtendedAppBar(name: "Student", username: "student", icon: UserIcons.getRandomIcon()),
            ],
          ),
        ),
      ),
    );
  }
}