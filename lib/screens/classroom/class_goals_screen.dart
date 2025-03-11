import 'package:bookworms_app/app_state.dart';
import 'package:bookworms_app/models/goals/classroom_goal.dart';
import 'package:bookworms_app/screens/classroom/class_goal_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:bookworms_app/resources/colors.dart';
import 'package:bookworms_app/utils/widget_functions.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';

class ClassGoalsScreen extends StatefulWidget {
  const ClassGoalsScreen({super.key});

  @override
  State<ClassGoalsScreen> createState() => _ClassGoalsScreenState();
}

var x = SystemUiOverlayStyle(
  // Status bar color
  statusBarColor: Colors.red,

  // Status bar brightness (optional)
  statusBarIconBrightness: Brightness.dark, // For Android (dark icons)
  statusBarBrightness: Brightness.light, // For iOS (dark icons)
);

class _ClassGoalsScreenState extends State<ClassGoalsScreen> {
  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    AppState appState = Provider.of<AppState>(context);
    List<ClassroomGoal> goals = appState.classroom!.classroomGoals;

    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: defaultOverlay(),
        title: const Text("Class Goals",
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
          itemCount: goals.length + 1,
          itemBuilder: (context, index) {
            if (index != 0) {
              return InkWell(
                child: classGoalItem(textTheme, index - 1),
                onTap: () async {
                  ClassroomGoal goal = await appState.getClassroomGoalStudentDetails(goals[index - 1].goalId);
                  if (mounted) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ClassGoalDetails(goal: goal)),
                    );
                  }
                }
              );
            } else {
              return _addClassGoalWidget(textTheme);
            }
          },
        ),
      ),
    );
  }

  Widget classGoalItem(TextTheme textTheme, int index) {
    AppState appState = Provider.of<AppState>(context);
    ClassroomGoal goal = appState.classroom!.classroomGoals[index];
    DateTime endDate = DateTime.parse(goal.endDate);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Container(
        decoration: BoxDecoration(
          color: colorWhite,
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(goal.title, style: textTheme.titleLarge),
                  Icon(Icons.arrow_forward_rounded, size: 24, color: colorGreyDark),
                ],
              ),
              addVerticalSpace(8),
              Text(
                "Completed by ${goal.studentsCompleted}/${goal.totalStudents} students", 
                style: textTheme.bodyMedium
              ),
              addVerticalSpace(8),
              LinearPercentIndicator(
                lineHeight: 8.0,
                percent: _getTimePercentage(goal.startDate, goal.endDate),
                progressColor: colorGreen,
                barRadius: const Radius.circular(4),
              ),
              addVerticalSpace(12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (goal.completionGoal != null) ...[
                        Text("Average Time", style: textTheme.bodyMedium),
                        Text(goal.completionGoal!.avgCompletionTime != null 
                          ? "${goal.completionGoal!.avgCompletionTime} min." 
                          : "--", 
                          style: textTheme.labelLarge
                        ),
                      ],
                      if (goal.numBooksGoal != null) ...[
                        Text("Average Books Read", style: textTheme.bodyMedium),
                        Text(goal.numBooksGoal!.avgBooksRead != null 
                          ? "${goal.numBooksGoal!.avgBooksRead} books." 
                          : "--", 
                          style: textTheme.labelLarge
                        ),
                      ]
                    ],
                  ),
                  SizedBox(
                    height: 40,
                    child: VerticalDivider(
                      color: Colors.black,
                      thickness: 1,
                      width: 20,
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text("End Date", style: textTheme.bodyMedium),
                      Text(
                        "${endDate.month}/${endDate.day}/${endDate.year}", 
                        style: textTheme.labelLarge
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Calculates the percentage of time between the start date, now, and the end date.
  double _getTimePercentage(String startDate, String endDate) {
    DateTime start = DateTime.parse(startDate);
    DateTime end = DateTime.parse(endDate);

    int totalDuration = end.difference(start).inDays;
    int elapsedDuration = DateTime.now().difference(start).inDays;

    return elapsedDuration / totalDuration;
  }

  Widget _addClassGoalWidget(TextTheme textTheme) {
    AppState appState = Provider.of<AppState>(context);
    List<ClassroomGoal> goals = appState.classroom!.classroomGoals;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: InkWell(
        child: Container(
          decoration: BoxDecoration(
            color: colorWhite,
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Row(
              children: [
                Text(
                  goals.isEmpty ? "Add your first class goal" : "Add a new goal", 
                  style: textTheme.titleMedium
                ),
                Spacer(),
                Icon(Icons.add_circle_outline, size: 32, color: colorGreyDark),
              ],
            )
          )
        ),
        onTap: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              TextEditingController titleController = TextEditingController();
              TextEditingController dateController = TextEditingController();
              String selectedMetric = "Completion";

              return StatefulBuilder(
                builder: (context, setState) {

                  // On click, pulls up the date picker.
                  Future<void> selectDate() async {
                    final DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2025),
                      lastDate: DateTime(2026)
                    );

                    setState(() {
                      dateController.text = pickedDate != null 
                        ? "${pickedDate.month}/${pickedDate.day}/${pickedDate.year}"
                        : "No selected date";
                    });
                  }

                  return AlertDialog(
                    title: Column(
                      children: [
                        Row(
                          children: [
                            Text("Add Class Goal"),
                            addHorizontalSpace(32),
                            InkWell(
                              onTap: () {
                                Navigator.of(context).pop();
                              },
                              child: Icon(Icons.cancel, size: 32, color: colorGreyDark),
                            ),
                            addHorizontalSpace(4),
                            InkWell(
                              onTap: () {},
                              child: Icon(Icons.check_circle_rounded, size: 32, color: colorGreen),
                            ),
                          ],
                        ),
                        Divider(color: colorGrey)
                      ],
                    ),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Goal Title.
                        TextField(
                          controller: titleController,
                          decoration: InputDecoration(
                            labelText: "Goal Title",
                            border: OutlineInputBorder(),
                          ),
                        ),
                        addVerticalSpace(16),
                        // End Date.
                        TextFormField(
                          controller: dateController,
                          readOnly: true,
                          onTap: selectDate,
                          decoration: InputDecoration(
                            labelText: "Select End Date",
                            border: OutlineInputBorder(),
                            suffixIcon: Icon(Icons.calendar_today),
                          ),
                        ),
                        addVerticalSpace(16),
                        // Metric Type.
                        DropdownButtonFormField<String>(
                          onChanged: (value) {
                            setState(() {
                              selectedMetric = value!;
                            });
                          },
                          items: ["Completion", "Number of Books"]
                            .map((metric) => DropdownMenuItem(
                              value: metric,
                              child: Text(metric, style: textTheme.bodyLarge),
                            ))
                            .toList(),
                          decoration: InputDecoration(
                            labelText: "Metric Type",
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          );
        }
      ),
    );
  }
}
