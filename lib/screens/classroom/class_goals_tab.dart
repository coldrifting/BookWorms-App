import 'package:bookworms_app/app_state.dart';
import 'package:bookworms_app/models/goals/classroom_goal.dart';
import 'package:bookworms_app/resources/theme.dart';
import 'package:bookworms_app/screens/classroom/class_goal_details.dart';
import 'package:flutter/material.dart';
import 'package:bookworms_app/resources/colors.dart';
import 'package:bookworms_app/utils/widget_functions.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';

class ClassGoalsScreen extends StatefulWidget {
  const ClassGoalsScreen({super.key});

  @override
  State<ClassGoalsScreen> createState() => _ClassGoalsScreenState();
}

class _ClassGoalsScreenState extends State<ClassGoalsScreen> {
  late List<ClassroomGoal> activeGoals;
  late List<ClassroomGoal> pastGoals;
  late List<ClassroomGoal> futureGoals;
  late List<ClassroomGoal> displayedGoals;
  late String selectedGoalsTitle;

  // Groups the goals into their respective lists (past / active / future goals).
  void _organizeGoals() {
    AppState appState = Provider.of<AppState>(context, listen: false);
    List<ClassroomGoal> goals = appState.classroom!.classroomGoals;

    activeGoals = [];
    pastGoals = [];
    futureGoals = [];

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
    displayedGoals = activeGoals;
    selectedGoalsTitle = "Active";
  }

  @override
  void initState() {
    super.initState();
    _organizeGoals();
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
            child: ListView.builder(
              itemCount: displayedGoals.length + 2,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Column(
                    children: [
                      _addClassGoalButton(textTheme),
                      addVerticalSpace(8),
                    ],
                  );
                } else if (index == 1) {
                  return Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _goalItemWidget(textTheme, "Active", Icons.alarm, activeGoals),
                          _goalItemWidget(textTheme, "Upcoming", Icons.flag, futureGoals),
                          _goalItemWidget(textTheme, "Past", Icons.check_circle_rounded, pastGoals),
                        ],
                      ),
                      addVerticalSpace(16),
                      if (displayedGoals.isEmpty) ...[
                        addVerticalSpace(16),
                        Center(
                          child: Text("No Goals to be Shown", style: TextStyle(color: colorGrey)),
                        )
                      ]
                    ],
                  );
                } else {
                  return Column(
                    children: [
                      _classGoalItem(
                        textTheme, 
                        displayedGoals[index - 2], 
                        _getGoalDetailsCallback(displayedGoals[index - 2], selectedGoalsTitle)
                      ),
                      addVerticalSpace(16),
                    ],
                  );
                }
              },
            )
          ),
        )
      ],
    );
  }

  /// Goal item (Active / Upcoming / Past Goals).
  Widget _goalItemWidget(TextTheme textTheme, String title, IconData icon, List<ClassroomGoal> goals) {
    bool isSelected = selectedGoalsTitle == title;

    return InkWell(
      onTap: () {
        setState(() {
          displayedGoals = goals;
          selectedGoalsTitle = title;
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: !isSelected ? colorWhite : colorGreenGradTop,
          border: Border.all(color: colorGreen!, width: isSelected ? 4 : 3),
          borderRadius: BorderRadius.circular(16),
          boxShadow: !isSelected
              ? [BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(0, 4))]
              : [],
        ),
        height: 125,
        width: 125,
        child: Align(
          alignment: Alignment.center, 
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: !isSelected ? colorGreen : colorWhite, size: 28),
              addVerticalSpace(4),
              Text(
                title, 
                style: !isSelected 
                  ? textTheme.titleMedium!.copyWith(color: colorGreen) 
                  : textTheme.titleMediumWhite, 
                textAlign: TextAlign.center
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Divider(color: !isSelected ? colorGreen : colorWhite),
              ),
              Text(
                "${goals.length} goal${goals.length == 1 ? "" : "s"}",
                style: !isSelected ? textTheme.bodyMediumWhite.copyWith(color: colorGreen) : textTheme.bodyMediumWhite, 
                textAlign: TextAlign.center
              )
            ],
          )
        ),
      ),
    );
  }

  Widget _addClassGoalButton(TextTheme textTheme) {
    return FractionallySizedBox(
      widthFactor: 0.4,
      child: TextButton(
        onPressed: () => _addClassGoalAlert(textTheme),
        style: TextButton.styleFrom(
          backgroundColor: colorGreen,
          foregroundColor: colorWhite,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Add New Goal"),
            addHorizontalSpace(8),
            Icon(Icons.add_chart, color: colorWhite),
          ],
        ),
      ),
    );
  }

  /// Alert modal for adding a new classroom goal.
  dynamic _addClassGoalAlert(TextTheme textTheme) {
    AppState appState = Provider.of<AppState>(context, listen: false);

    return showDialog(
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
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    backgroundColor: colorGreenDark,
                                    content: Row(
                                        children: [
                                          Text(
                                            'Successfully created class goal!', 
                                            style: textTheme.titleSmallWhite,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          Spacer(),
                                          Icon(Icons.check_circle_outline_rounded, color: colorWhite)
                                        ],
                                      ),
                                    duration: Duration(seconds: 2),
                                  ),
                                );
                                Navigator.pop(context);
                              }
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
          }
        );
      }
    );
  }

  Widget _classGoalItem(TextTheme textTheme, ClassroomGoal goal, Widget Function(ClassroomGoal) getGoalDetailsWidget) {
    AppState appState = Provider.of<AppState>(context);

    return Container(
      decoration: BoxDecoration(
        color: colorWhite,
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: InkWell(
        onTap: () => _navigateToGoalDetails(context, appState, goal),
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
        _completionBarWidget(goal.studentsCompleted, goal.totalStudents),
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
                  Text("Avg. Books Read", style: textTheme.bodyMedium),
                  Text(goal.numBooksGoal!.avgBooksRead != null 
                    ? "${goal.numBooksGoal!.avgBooksRead}" 
                    : "--", 
                    style: textTheme.labelLarge
                  ),
                ]
              ],
            ),
            if (goal.numBooksGoal != null) ...[
              SizedBox(
                height: 40,
                child: VerticalDivider(
                  color: Colors.black,
                  thickness: 1,
                  width: 20,
                ),
              ),
              Column(
                children: [
                  Text("Target Books", style: textTheme.bodyMedium),
                  Text(
                    "${goal.numBooksGoal!.targetNumBooks}",
                    style: textTheme.labelLarge
                  ),
                ],
              ),
            ],
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
  Widget _completionBarWidget(int numStudentsCompleted, int numTotalStudents) {
    double percentCompleted = numStudentsCompleted / numTotalStudents;
    Color barColor;
    if (percentCompleted < 0.5) {
      barColor = colorRed!;
    } else if (percentCompleted < 0.9) {
      barColor = colorYellow;
    } else {
      barColor = colorGreen!;
    }

    return LinearPercentIndicator(
      lineHeight: 8.0,
      percent: percentCompleted,
      progressColor: barColor,
      barRadius: const Radius.circular(4),
      backgroundColor: Colors.grey[300],
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
  Widget Function(ClassroomGoal) _getGoalDetailsCallback(ClassroomGoal goal, String title) {
    if (title.contains("Upcoming")) {
      return _futureGoalDetails;
    } else {
      return _goalDetails;
    }
  }
}
