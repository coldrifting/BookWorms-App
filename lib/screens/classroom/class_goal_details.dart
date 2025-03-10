import 'package:bookworms_app/resources/colors.dart';
import 'package:bookworms_app/utils/widget_functions.dart';
import 'package:flutter/material.dart';

class ClassGoalDetails extends StatefulWidget {
  const ClassGoalDetails({super.key});

  @override
  State<ClassGoalDetails> createState() => _ClassGoalDetailsState();
}

class _ClassGoalDetailsState extends State<ClassGoalDetails> {
  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: defaultOverlay(),
        title: const Text("Daily Reading",
          style: TextStyle(
            fontWeight: FontWeight.bold,
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
      body: ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) {
          return _studentItem(textTheme);
        },
      ),
    );
  }

  Widget _studentItem(TextTheme textTheme) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          CircleAvatar(),
          addHorizontalSpace(8),
          Text("Student Name"),
          Spacer(),
          Text("Complete")
        ],
      ),
    );
  }
}