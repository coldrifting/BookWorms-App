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
  List<ClassroomGoal> activeGoals = [];
  List<ClassroomGoal> pastGoals = [];
  List<ClassroomGoal> futureGoals = [];

  @override
  void initState() {
    super.initState();
    _organizeGoals();
  }

  // Groups the goals into their respective lists (past / active / future goals).
  void _organizeGoals() {
    AppState appState = Provider.of<AppState>(context, listen: false);
    List<ClassroomGoal> goals = appState.classroom!.classroomGoals;

    for (var goal in goals) {
      DateTime start = DateTime.parse(goal.startDate);
      DateTime end = DateTime.parse(goal.endDate);
      if (DateTime.now().isBefore(start)) { // Future goal.
        futureGoals.add(goal);
      } else if (DateTime.now().isAfter(end)) { // Past goal.
        pastGoals.add(goal);
      } else { // Active goal.
        activeGoals.add(goal);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    AppState appState = Provider.of<AppState>(context);

    List<dynamic> goalItems = [
      if (activeGoals.isNotEmpty) 'Active Goals', 
      ...activeGoals, 
      if (futureGoals.isNotEmpty) 'Upcoming Goals', 
      ...futureGoals,
      if (pastGoals.isNotEmpty) 'Past Goals', 
      ...pastGoals
    ];

    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: defaultOverlay(),
        title: const Text(
          "Class Goals",
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
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Container(
        color: colorGreyLight,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView.builder(
            itemCount: goalItems.length + 1,
            itemBuilder: (context, index) {
              // Add class goal button.
              if (index == 0) {
                return Column(
                  children: [
                    _addClassGoalWidget(textTheme),
                  ],
                );
              }
          
              // Header string ('Active Goals', 'Past Goals', 'Upcoming Goals')
              dynamic item = goalItems[index - 1];
              if (item is String) {
                return Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Column(
                    children: [
                      const Divider(height: 1, color: Colors.grey),
                      addVerticalSpace(12),
                      Center(
                        child: Text(
                          item, 
                          style: textTheme.headlineMedium!.copyWith(color: colorGreen)
                        ),
                      ),
                    ],
                  ),
                );
              }
          
              // Classroom goal item.
              Widget Function(ClassroomGoal) callback = _getGoalDetailsCallback(item);
                return Column(
                children: [
                  InkWell(
                    onTap: () => _navigateToGoalDetails(context, appState, item),
                    child: _classGoalItem(textTheme, item, callback),
                  ),
                  addVerticalSpace(8),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  // Navigates from classroom goal screen to goal detail screen (displays all students' completion status).
  Future<void> _navigateToGoalDetails(BuildContext context, AppState appState, ClassroomGoal goal) async {
    ClassroomGoal detailedGoal = await appState.getClassroomGoalStudentDetails(goal.goalId);
    if (context.mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ClassGoalDetails(goal: detailedGoal)),
      );
    }
  }

  // Gets the function callback related to the specific goal (active/past or future).
  Widget Function(ClassroomGoal) _getGoalDetailsCallback(ClassroomGoal goal) {
    if (activeGoals.contains(goal) || pastGoals.contains(goal)) {
      return _goalDetails;
    } else {
      return _futureGoalDetails;
    }
  }

  Widget _classGoalItem(TextTheme textTheme, ClassroomGoal goal, Widget Function(ClassroomGoal) getGoalDetailsWidget) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
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
                  Flexible(
                    child: Text(
                      goal.title, 
                      style: textTheme.titleSmall,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Icon(Icons.arrow_forward_rounded, size: 24, color: colorGreyDark),
                ],
              ),
              addVerticalSpace(8),
              getGoalDetailsWidget(goal)
            ],
          ),
        ),
      ),
    );
  }

  Widget _goalDetails(ClassroomGoal goal) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    DateTime endDate = DateTime.parse(goal.endDate);

    return Column(
      children: [
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
                Text("Due Date", style: textTheme.bodyMedium),
                Text(
                  "${endDate.month}/${endDate.day}/${endDate.year}", 
                  style: textTheme.labelLarge
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _futureGoalDetails(ClassroomGoal goal) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    DateTime startDate = DateTime.parse(goal.startDate);
    DateTime endDate = DateTime.parse(goal.endDate);

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("Start Date", style: textTheme.bodyMedium),
                Text(
                  "${startDate.month}/${startDate.day}/${startDate.year}", 
                  style: textTheme.labelLarge
                ),
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
                Text("Due Date", style: textTheme.bodyMedium),
                Text(
                  "${endDate.month}/${endDate.day}/${endDate.year}", 
                  style: textTheme.labelLarge
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  // Calculates the percentage of time between the start date, now, and the end date.
  double _getTimePercentage(String startDate, String endDate) {
    DateTime start = DateTime.parse(startDate);
    DateTime end = DateTime.parse(endDate);

    int totalDuration = end.difference(start).inDays;
    int elapsedDuration = DateTime.now().difference(start).inDays;

    if (DateTime.now().isAfter(end)) {
      return 1;
    }

    return elapsedDuration / totalDuration;
  }

  Widget _addClassGoalWidget(TextTheme textTheme) {
    AppState appState = Provider.of<AppState>(context);
    List<ClassroomGoal> goals = appState.classroom!.classroomGoals;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
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
              final formKey = GlobalKey<FormState>();
              
              String selectedMetric = "Completion";
              DateTime? pickedDate;

              return StatefulBuilder(
                builder: (context, setState) {

                  // On click, pulls up the date picker.
                  Future<void> selectDate() async {
                    pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2025),
                      lastDate: DateTime(2026)
                    );

                    setState(() {
                      dateController.text = pickedDate != null 
                        ? "${pickedDate!.month}/${pickedDate!.day}/${pickedDate!.year}"
                        : "No selected date";
                    });
                  }

                  return Form(
                    key: formKey,
                    child: AlertDialog(
                      title: Column(
                        children: [
                          Row(
                            children: [
                              Text("Add Class Goal"),
                              addHorizontalSpace(32),
                              InkWell(
                                onTap: () => Navigator.of(context).pop(),
                                child: Icon(Icons.cancel, size: 32, color: colorGreyDark),
                              ),
                              addHorizontalSpace(4),
                              InkWell(
                                onTap: () {
                                  if (formKey.currentState?.validate() ?? false) {
                                    appState.addClassroomGoal(
                                      titleController.text, 
                                      "${pickedDate!.year}-${pickedDate!.month.toString().padLeft(2, '0')}-${pickedDate!.day.toString().padLeft(2, '0')}"
                                    );
                                  }
                                },
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
                          TextFormField(
                            controller: titleController,
                            decoration: InputDecoration(
                              labelText: "Goal Title",
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please input a goal title';
                              }
                              return null;
                            },
                          ),
                          addVerticalSpace(16),
                          // End Date.
                          TextFormField(
                            controller: dateController,
                            readOnly: true,
                            onTap: selectDate,
                            decoration: InputDecoration(
                              labelText: "Select Due Date",
                              border: OutlineInputBorder(),
                              suffixIcon: Icon(Icons.calendar_today),
                            ),
                            validator: (value) {
                              if (value == null || value == "No selected date") {
                                return 'Please input a due date';
                              }
                              return null;
                            },
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
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please select a metric';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
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
