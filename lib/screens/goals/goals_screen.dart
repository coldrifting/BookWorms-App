import 'package:bookworms_app/app_state.dart';
import 'package:bookworms_app/models/goals/child_goal.dart';
import 'package:bookworms_app/models/goals/classroom_goal.dart';
import 'package:bookworms_app/resources/theme.dart';
import 'package:bookworms_app/screens/classroom/class_goal_details.dart';
import 'package:bookworms_app/screens/goals/goal_modal.dart';
import 'package:bookworms_app/utils/widget_functions.dart';
import 'package:bookworms_app/widgets/completion_bar.dart';
import 'package:flutter/material.dart';
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
  }

  @override
  void initState() {
    super.initState();
    _organizeGoals();
    displayedGoals = activeGoals;
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    _organizeGoals();

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
                      _getGoalDetailsCallback(goal, selectedGoalsTitle),
                      selectedGoalsTitle
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
            child: Text("No Goals to be Shown", style: TextStyle(color: context.colors.greyDark)),
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
          color: isSelected ? context.colors.gradTop : context.colors.surface,
          border: Border.all(color: context.colors.primary, width: isSelected ? 4 : 3),
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
              Icon(icon, color: isSelected ? context.colors.onPrimary : context.colors.primary, size: 28),
              addVerticalSpace(4),
              Text(
                title, 
                style: isSelected 
                  ? textTheme.titleMediumWhite
                  : textTheme.titleMedium!.copyWith(color: context.colors.primary),
                textAlign: TextAlign.center
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Divider(color: !isSelected ? context.colors.primary : context.colors.onPrimary),
              ),
              Text(
                "${goals.length} goal${goals.length == 1 ? "" : "s"}",
                style: !isSelected ? textTheme.bodyMediumWhite.copyWith(color: context.colors.primary) : textTheme.bodyMediumWhite,
                textAlign: TextAlign.center
              )
            ],
          )
        ),
      ),
    );
  }

  Widget _addGoalButton(TextTheme textTheme) {
    return SizedBox(
      width: 180,
      child: TextButton(
        onPressed: () { 
          goalAlert(context, "", _organizeGoals);
        },
        style: smallButtonStyle,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Add New Goal"),
            addHorizontalSpace(8),
            Icon(Icons.add_chart),
          ],
        ),
      ),
    );
  }

  Widget _goalItem(TextTheme textTheme, dynamic goal, Widget Function(dynamic) getGoalDetailsWidget, String goalTitle) {
    AppState appState = Provider.of<AppState>(context);

    return Container(
      decoration: BoxDecoration(
        color: context.colors.surface,
        border: Border.all(color: context.colors.surfaceBorder),
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
                children: [
                  if (appState.isParent && goal.goalType == "Classroom") ...[
                    Icon(Icons.school),
                    addHorizontalSpace(8),
                  ],
                  Expanded(
                    child: Text(
                      goal.title, 
                      style: textTheme.titleSmall,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (!appState.isParent) ...[
                    Spacer(),
                    Icon(Icons.arrow_forward_rounded, size: 24, color: context.colors.onSurfaceDim),
                  ]
                ],
              ),
              addVerticalSpace(8),
              getGoalDetailsWidget(goal),
              addVerticalSpace(8),
              if ((appState.isParent && goalTitle != "Upcoming") ||
                (goal.goalType != "Classroom" && goal.goalType != "ClassroomAggregate"))
                TextButton.icon(
                  onPressed: () {
                    goalAlert(context, goalTitle, _organizeGoals, goal);
                  }, 
                    style: buttonStyle(context, context.colors.secondary, context.colors.onSurface, radius: 8),
                    label: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(goal.goalType == "Classroom" || goal.goalType == "ClassroomAggregate" 
                        ? "Log" :"Edit",
                      ),
                      addHorizontalSpace(6),
                      Icon(Icons.edit)
                    ],
                  )
                )
            ],
          ),
        ),
      ),
    );
  }

  Widget _classGoalDetails(dynamic goal) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    AppState appState = Provider.of<AppState>(context);
    DateTime endDate = DateTime.parse(goal.endDate);

    return Column(
      children: [
        if (!appState.isParent) ...[
          Text(
            "Completed by ${goal.classGoalDetails.studentsCompleted}/${goal.classGoalDetails.studentsTotal} students",
            style: textTheme.bodyMedium
          ),
          addVerticalSpace(8),
          completionBarWidget(context, goal.classGoalDetails.studentsCompleted, goal.classGoalDetails.studentsTotal),
          addVerticalSpace(12),
        ],
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (goal.goalMetric == "Completion") ...[
                  Text("${appState.isParent ? "" : "Average "}Progress", style: textTheme.bodyMedium),
                  Text("${goal.progress.toString()}%", // TODO
                    //? "${goal.progress.toString().substring(3)} min." 
                    //: "--", 
                    style: textTheme.labelLarge
                  ),
                ],
                if (goal.goalMetric == "BooksRead") ...[
                  Text("${appState.isParent ? "" : "Avg. "}Books Read", style: textTheme.bodyMedium),
                  Text(goal.progress.toString(), style: textTheme.labelLarge),
                ]
              ],
            ),
            if (goal.goalMetric == "NumBooks") ...[
              SizedBox(
                height: 40,
                child: VerticalDivider(
                  color: context.colors.onSurfaceDim,
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
                color: context.colors.onSurfaceDim,
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

  Widget _childGoalDetails(dynamic goal) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    goal = goal as ChildGoal;
    DateTime startDate = DateTime.parse(goal.startDate);
    DateTime endDate = DateTime.parse(goal.endDate);
    int progress = goal.progress;
    if (goal.goalMetric == "Completion") {
      progress = parseProgress(progress)[1];
    }

    return Column(
      children: [
        if (goal.goalMetric == "BooksRead") ... [
          Text("Progress: $progress/${goal.target} read", style: textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold)),
          addVerticalSpace(8),
          completionBarWidget(context, goal.progress, goal.target),
        ],
        if (goal.goalMetric == "Completion") ...[
          Text("Progress: $progress%", style: textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold)),
          addVerticalSpace(8),
          completionBarWidget(context, progress, 100),
        ],
        addVerticalSpace(12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("Start Date", style: textTheme.bodyMedium),
                Text(convertDateToString(startDate), style: textTheme.labelLarge),
              ],
            ),
            if (goal.goalMetric == "NumBooks") ...[
              SizedBox(
                height: 40,
                child: VerticalDivider(
                  thickness: 1,
                  width: 20,
                ),
              ),
              Column(
                children: [
                  Text("Target Books", style: textTheme.bodyMedium),
                  Text("${goal.target}", style: textTheme.labelLarge),
                ],
              ),
            ],
            SizedBox(
              height: 40,
              child: VerticalDivider(
                thickness: 1,
                width: 20,
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("Due Date", style: textTheme.bodyMedium),
                Text(convertDateToString(endDate), style: textTheme.labelLarge),
              ],
            ),
          ],
        ),
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
                color: context.colors.onSurfaceDim,
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

  // Navigates from classroom goal screen to goal detail screen (displays all students' completion status).
  Future<void> _navigateToGoalDetails(BuildContext context, AppState appState, ClassroomGoal goal) async {
    ClassroomGoal detailedGoal = await appState.getDetailedClassroomGoalDetails(goal.goalId!);
    if (context.mounted) {
      pushScreen(context, ClassGoalDetails(goal: detailedGoal));
    }
  }

  // Gets the function callback related to the specific goal (active/past or future).
  Widget Function(dynamic goal) _getGoalDetailsCallback(dynamic goal, String title) {
    if (title.contains("Upcoming")) {
      return _futureGoalDetails;
    } else if (goal.goalType == "Classroom") {
      return _classGoalDetails;
    } else {
      return _childGoalDetails;
    }
  }
}