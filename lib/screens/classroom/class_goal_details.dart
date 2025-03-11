import 'package:bookworms_app/models/goals/classroom_goal.dart';
import 'package:bookworms_app/models/goals/student_goal_status.dart';
import 'package:bookworms_app/resources/colors.dart';
import 'package:bookworms_app/utils/user_icons.dart';
import 'package:bookworms_app/utils/widget_functions.dart';
import 'package:flutter/material.dart';

class ClassGoalDetails extends StatefulWidget {
  final ClassroomGoal goal;
  
  const ClassGoalDetails({super.key, required this.goal});

  @override
  State<ClassGoalDetails> createState() => _ClassGoalDetailsState();
}

class _ClassGoalDetailsState extends State<ClassGoalDetails> {
  late ClassroomGoal goal;

  @override
  void initState() {
    super.initState();
    goal = widget.goal;
  }

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
        itemCount: goal.studentGoalStatus!.length,
        itemBuilder: (context, index) {
          return _studentItem(textTheme, goal.studentGoalStatus![index]);
        },
      ),
    );
  }

  Widget _studentItem(TextTheme textTheme, StudentGoalStatus studentGoalStatus) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          CircleAvatar(child: UserIcons.getIcon(studentGoalStatus.childIcon)),
          addHorizontalSpace(8),
          Text(studentGoalStatus.childName),
          Spacer(),
          if (studentGoalStatus.hasAchievedGoal)
            Text("COMPLETE", style: TextStyle(color: colorGreen))
          else 
            Text("INCOMPLETE", style: TextStyle(color: colorRed))
        ],
      ),
    );
  }
}