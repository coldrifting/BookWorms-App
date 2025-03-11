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
    DateTime endDate = DateTime.parse(goal.endDate);
    int daysLeft = endDate.difference(DateTime.now()).inDays;

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
        itemCount: goal.studentGoalStatus!.length + 1,
        itemBuilder: (context, index) {
          // Student Completion Information.
          if (index == 0) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                    alignment: Alignment.center,
                    child: Column(
                      children: [
                        Text(
                          "${goal.studentsCompleted}/${goal.totalStudents} students completed this goal",
                          style: textTheme.titleSmall,
                        ),
                        if (daysLeft > 0)
                        Text(
                          "$daysLeft day${daysLeft == 1 ? "" : "s"} until due date"
                        )
                      ],
                    ),
                  ),
                ),
                Divider(),
              ],
            );
          }

          // Student list.
          return Column(
            children: [
              _studentItem(textTheme, goal.studentGoalStatus![index - 1]),
              Divider()
            ],
          );
        },
      ),
    );
  }

  Widget _studentItem(TextTheme textTheme, StudentGoalStatus studentGoalStatus) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          CircleAvatar(
            maxRadius: 35,
            child: SizedBox.expand(
              child: FittedBox(
                child: UserIcons.getIcon(studentGoalStatus.childIcon),
              ),
            ),
          ),
          addHorizontalSpace(16),
          Text(studentGoalStatus.childName, style: textTheme.titleMedium),
          Spacer(),
          if (studentGoalStatus.hasAchievedGoal)
            Text("COMPLETE", style: TextStyle(color: colorGreen))
          else 
            Text("INCOMPLETE", style: TextStyle(color: colorRed, fontWeight: FontWeight.bold))
        ],
      ),
    );
  }
}