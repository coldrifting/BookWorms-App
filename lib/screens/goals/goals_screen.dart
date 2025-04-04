import 'package:bookworms_app/app_state.dart';
import 'package:bookworms_app/models/goals/classroom_goal.dart';
import 'package:bookworms_app/resources/colors.dart';
import 'package:bookworms_app/resources/theme.dart';
import 'package:bookworms_app/screens/classroom/class_goal_details.dart';
import 'package:bookworms_app/screens/goals/add_goal_modal.dart';
import 'package:bookworms_app/utils/widget_functions.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';

class GoalsScreen extends StatefulWidget {
  const GoalsScreen({super.key});

  @override
  State<GoalsScreen> createState() => _GoalsScreenState();
}

class _GoalsScreenState extends State<GoalsScreen> {
  late dynamic goals;
  late dynamic activeGoals = [];
  late dynamic pastGoals = [];
  late dynamic futureGoals = [];
  late dynamic displayedGoals;
  late String selectedGoalsTitle = "Active";

  // Groups the goals into their respective lists (past / active / future goals).
  void _organizeGoals() {
    AppState appState = Provider.of<AppState>(context, listen: false);

    goals = appState.goals;
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
                if (index == 0) { return _addGoalSection(textTheme); }
                else if (index == 1) { return _goalCategorySelector(textTheme); } 

                final goal = displayedGoals[index - 2];
                return Column(
                  children: [
                    _goalItem(
                      textTheme, 
                      goal,
                      _getGoalDetailsCallback(goal, selectedGoalsTitle)
                    ),
                    addVerticalSpace(16),
                  ],
                );
              },
            )
          ),
        )
      ],
    );
  }

  Widget _addGoalSection(TextTheme textTheme) {
    return Column(
      children: [
        _addGoalButton(textTheme),
        addVerticalSpace(8),
      ],
    );
  }

  Widget _goalCategorySelector(TextTheme textTheme) {
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
            child: Text("No Goals to be Shown", style: TextStyle(color: colorGreyDark)),
          )
        ]
      ],
    );
  }

  /// Goal item (Active / Upcoming / Past Goals).
  Widget _goalItemWidget(TextTheme textTheme, String title, IconData icon, dynamic goals) {
    bool isSelected = selectedGoalsTitle == title;

    return InkWell(
      onTap: () => setState(() {
        displayedGoals = goals;
        selectedGoalsTitle = title;
      }),
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? colorGreenGradTop : colorWhite,
          border: Border.all(color: colorGreen, width: isSelected ? 4 : 3),
          borderRadius: BorderRadius.circular(16),
          boxShadow: isSelected
            ? []
            : [BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(0, 4))],
        ),
        height: 125,
        width: 125,
        child: Align(
          alignment: Alignment.center, 
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: isSelected ? colorWhite : colorGreen, size: 28),
              addVerticalSpace(4),
              Text(
                title, 
                style: isSelected 
                  ? textTheme.titleMediumWhite
                  : textTheme.titleMedium!.copyWith(color: colorGreen), 
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

  Widget _addGoalButton(TextTheme textTheme) {
    return FractionallySizedBox(
      widthFactor: 0.4,
      child: TextButton(
        onPressed: () { 
          addGoalAlert(context, _organizeGoals);
        },
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

  Widget _goalItem(TextTheme textTheme, dynamic goal, Widget Function(dynamic) getGoalDetailsWidget) {
    AppState appState = Provider.of<AppState>(context);

    return Container(
      decoration: BoxDecoration(
        color: colorWhite,
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: InkWell(
        onTap: () {
          if (!appState.isParent) { _navigateToGoalDetails(context, appState, goal); }
        },
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

  Widget _goalDetails(dynamic goal) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    AppState appState = Provider.of<AppState>(context);

    DateTime endDate = DateTime.parse(goal.endDate);

    return Column(
      children: [
        if (!appState.isParent) ... [
          Text(
            "Completed by ${goal.classGoalDetails.studentsCompleted}/${goal.classGoalDetails.studentsTotal} students", 
            style: textTheme.bodyMedium
          ),
          addVerticalSpace(8),
          _completionBarWidget(goal.classGoalDetails.studentsCompleted, goal.classGoalDetails.studentsTotal),
          addVerticalSpace(12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (goal.goalMetric == "Completion") ...[
                    Text("Average Time", style: textTheme.bodyMedium),
                    Text(goal.progress.toString(), // TODO
                      //? "${goal.progress.toString().substring(3)} min." 
                      //: "--", 
                      style: textTheme.labelLarge
                    ),
                  ],
                  if (goal.goalMetric == "BooksRead") ...[
                    Text("Avg. Books Read", style: textTheme.bodyMedium),
                    Text(
                      goal.progress.toString(), 
                      style: textTheme.labelLarge
                    ),
                  ]
                ],
              ),
              if (goal.goalMetric == "NumBooks") ...[
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
                      "${goal.target}",
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
      ],
    );
  }

  Widget _futureGoalDetails(dynamic goal) {
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
    double percentCompleted = numTotalStudents == 0 ? 0.0 : numStudentsCompleted / numTotalStudents;
    Color barColor;
    if (percentCompleted < 0.5) {
      barColor = colorRed;
    } else if (percentCompleted < 0.9) {
      barColor = colorYellow;
    } else {
      barColor = colorGreen;
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
    ClassroomGoal detailedGoal = await appState.getDetailedClassroomGoalDetails(goal.goalId!);
    if (context.mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ClassGoalDetails(goal: detailedGoal)),
      );
    }
  }

  // Gets the function callback related to the specific goal (active/past or future).
  Widget Function(dynamic) _getGoalDetailsCallback(dynamic goal, String title) {
    if (title.contains("Upcoming")) {
      return _futureGoalDetails;
    } else {
      return _goalDetails;
    }
  }
}