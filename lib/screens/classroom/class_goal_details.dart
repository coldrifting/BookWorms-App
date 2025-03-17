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
    DateTime startDate = DateTime.parse(goal.startDate);
    DateTime endDate = DateTime.parse(goal.endDate);
    int daysLeft = endDate.difference(DateTime.now()).inDays;

    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: defaultOverlay(),
        title: Text(goal.title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
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
      body: Container(
        color: colorGreyLight,
        child: ListView.builder(
          itemCount: goal.studentGoalStatus!.length + 1,
          itemBuilder: (context, index) {
            // Student Completion Information.
            if (index == 0) {
              return Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: colorWhite,
                      border: Border(
                        bottom: BorderSide(color: colorGrey),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Align(
                        alignment: Alignment.center,
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Column(
                                  children: [
                                    Text("Start Date", style: textTheme.bodyMedium),
                                    Text(
                                      "${startDate.month}/${startDate.day}/${startDate.year}", 
                                      style: textTheme.labelLarge
                                    ),
                                  ],
                                ),
                                addHorizontalSpace(16),
                                SizedBox(
                                  height: 40,
                                  child: VerticalDivider(
                                    color: Colors.black,
                                    thickness: 1,
                                    width: 20,
                                  ),
                                ),
                                addHorizontalSpace(16),
                                Column(
                                  children: [
                                    Text("Due Date", style: textTheme.bodyMedium),
                                    Text(
                                      "${endDate.month}/${endDate.day}/${endDate.year}", 
                                      style: textTheme.labelLarge
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            addVerticalSpace(12),
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
                  ),
                  addVerticalSpace(8),
                ],
              );
            }
        
            // Student list.
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Container(
                color: colorWhite,
                child: Column(
                  children: [
                    _studentItem(textTheme, goal.studentGoalStatus![index - 1]),
                    if (goal.studentGoalStatus!.length != index) Divider(color: colorGreyLight)
                  ],
                ),
              ),
            );
          },
        ),
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
            Text("COMPLETE", style: TextStyle(color: colorGreen, fontWeight: FontWeight.bold))
          else 
            Text("INCOMPLETE", style: TextStyle(color: colorRed, fontWeight: FontWeight.bold))
        ],
      ),
    );
  }
}