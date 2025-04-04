import 'package:bookworms_app/app_state.dart';
import 'package:bookworms_app/models/child/child.dart';
import 'package:bookworms_app/models/goals/child_goal.dart';
import 'package:bookworms_app/models/goals/classroom_goal.dart';
import 'package:bookworms_app/models/goals/classroom_goal_details.dart';
import 'package:bookworms_app/resources/colors.dart';
import 'package:bookworms_app/screens/classroom/class_goal_details.dart';
import 'package:bookworms_app/screens/goals/add_goal_modal.dart';
import 'package:bookworms_app/utils/widget_functions.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GoalDashboard extends StatefulWidget {
  const GoalDashboard({super.key});

  @override
  State<GoalDashboard> createState() => _GoalDashboardState();
}

class _GoalDashboardState extends State<GoalDashboard> {
  static const int _numPages = 13;
  static const int _initialCalendarIndex = 6;

  late int selectedCalendarIndex;
  late DateTime currentDate;
  late PageController calendarPageController;
  late PageController goalPageController;

  @override
  void initState() {
    super.initState();
    selectedCalendarIndex = _initialCalendarIndex;
    currentDate = DateTime.now();
    calendarPageController = PageController(initialPage: selectedCalendarIndex, viewportFraction: 0.3);
    goalPageController = PageController(initialPage: 0, viewportFraction: 0.9);
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final appState = Provider.of<AppState>(context);

    final goals = appState.isParent 
      ? appState.children[appState.selectedChildID].goals
      : appState.classroom!.classroomGoals;

    final goalData = _getDayGoalsDetails(goals);
    var activeGoals = goalData[0];
    List<int> goalCounts = goalData[1];

    return Column(
      children: [
        SizedBox(
          height: 115,
          child: PageView.builder(
            controller: calendarPageController,
            scrollDirection: Axis.horizontal,
            itemCount: _numPages,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.only(left: 8.0, bottom: 12.0, right: 8.0),
                child: InkWell(
                  onTap: () {
                    setState(() {
                      selectedCalendarIndex = index;
                      calendarPageController.animateToPage(
                        index,
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    });
                  },
                  child: _calendarItem(
                    textTheme,
                    currentDate.subtract(Duration(days: (_numPages / 2).toInt() - index)), 
                    index,
                    goalCounts[index]
                  )
                ),
              );
            },
          ),
        ),
        SizedBox(
          height: 275,
          child: activeGoals[selectedCalendarIndex].isNotEmpty
          ? PageView.builder(
            controller: goalPageController,
            scrollDirection: Axis.horizontal,
            itemCount: activeGoals[selectedCalendarIndex].length,
            itemBuilder: (context, index) {
              DateTime selectedDate = DateTime.now().add(Duration(days: selectedCalendarIndex - 6));
              dynamic selectedGoal = activeGoals[selectedCalendarIndex][index];

              return Padding(
                padding: EdgeInsets.only(bottom: 12.0),
                child: InkWell(
                  onTap: () => _navigateToDetailedGoalScreen(selectedGoal),
                  child: _goalItem(
                    textTheme, 
                    selectedGoal, 
                    selectedDate
                  )
                )
              );
            },
          )
          : _noGoalsWidget(textTheme)
        ),
      ],
    );
  }

  void _navigateToDetailedGoalScreen(dynamic selectedGoal) async {
    final appState = Provider.of<AppState>(context, listen: false);
    if (!appState.isParent) {
      ClassroomGoal detailedGoal = await appState.getDetailedClassroomGoalDetails(selectedGoal.goalId!);
      if (mounted) {
        pushScreen(context, ClassGoalDetails(goal: detailedGoal));
      }
    } else {
      Child selectedChild = appState.children[appState.selectedChildID];
      ChildGoal detailedGoal = await appState.getChildGoalDetails(selectedChild, selectedGoal.goalId!);
      // TODO: Navigate to child goal details screen.
    }
  }

  // Returns the list of currently-active goals and the count of goals due.
  List<dynamic> _getDayGoalsDetails(List<dynamic> allGoals) {
    final now = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

    // Generate both the list of goals for each day and the goal counts.
    final goalData = List.generate(_numPages, (i) {
      final date = now.add(Duration(days: i - _initialCalendarIndex));
      
      // Initialize the list to hold goals for the current date and a counter for goals due.
      List<dynamic> goalsForDate = [];
      int goalsDue = 0;

      // Loop through all goals to filter the ones due for the current date.
      for (dynamic goal in allGoals) {
        final start = DateTime.parse(goal.startDate);
        final end = DateTime.parse(goal.endDate);
        final startDate = DateTime(start.year, start.month, start.day);
        final endDate = DateTime(end.year, end.month, end.day);

        // Check if the current date is within the goal's start and end date range.
        if (!date.isBefore(startDate) && !date.isAfter(endDate)) {
          goalsForDate.add(goal);

          // Check if the goal is due on the current date
          if (date.difference(endDate).inDays == 0) {
            goalsDue++;
          }
        }
      }

      // Sort the goals by their end date.
      goalsForDate.sort((a, b) => a.endDate.compareTo(b.endDate));
      
      // Return a map containing the list of goals for the date and the count of due goals.
      return {'goalsForDate': goalsForDate, 'goalCount': goalsDue};
    });

    // Separate out the lists of goals and goal counts.
    final goalLists = goalData.map((data) => data['goalsForDate'] as List).toList();
    final goalCounts = goalData.map((data) => data['goalCount'] as int).toList();
    return [goalLists, goalCounts];
  }

  // "No goals to show" display.
  Widget _noGoalsWidget(TextTheme textTheme) {
    final appState = Provider.of<AppState>(context);
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: colorBlack.withValues(alpha: 0.2),
            spreadRadius: 1,
            blurRadius: 6,
            offset: const Offset(0, 4),
          ),
        ],
        borderRadius: BorderRadius.circular(4.0),
        color: colorWhite,
      ),
      margin: const EdgeInsets.only(left: 8.0, right: 8.0, top: 16.0, bottom: 28.0),
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      width: 355,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "No ${appState.isParent ? '' : 'class '}goals assigned today.\nAdd one now!", 
              textAlign: TextAlign.center
            ),
            addVerticalSpace(8),
            _addGoalButton(textTheme)
          ],
        )
      )
    );
  }

  Widget _addGoalButton(TextTheme textTheme) {
    return FractionallySizedBox(
      widthFactor: 0.5,
      child: TextButton(
        onPressed: () => addGoalAlert(textTheme, context),
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

  Widget _goalItem(TextTheme textTheme, dynamic goal, DateTime date) {
    final appState = Provider.of<AppState>(context);
    final int percentCompleted;

    if (appState.isParent) {
      percentCompleted = goal.progress;
    } else {
      final ClassroomGoalDetails goalDetails = goal.classGoalDetails!;
      percentCompleted = goalDetails.studentsTotal != 0
          ? ((goalDetails.studentsCompleted / goalDetails.studentsTotal) * 100).toInt()
          : 0;
    }

    final selectedDate = DateTime(date.year, date.month, date.day);
    final endParsed = DateTime.parse(goal.endDate);
    final endDate = DateTime(endParsed.year, endParsed.month, endParsed.day);
    int daysRemaining = endDate.difference(selectedDate).inDays;

    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: colorBlack.withValues(alpha: 0.2),
            spreadRadius: 1,
            blurRadius: 6,
            offset: const Offset(0, 4),
          ),
        ],
        borderRadius: BorderRadius.circular(4.0),
        color: colorWhite,
      ),
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      height: 230,
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(goal.title, style: textTheme.titleMedium!.copyWith(color: colorGreen), overflow: TextOverflow.ellipsis),
              addVerticalSpace(4),
              Column(
                children: [
                  Row(children: [
                    addVerticalSpace(8),
                    ConstrainedBox(
                        constraints: BoxConstraints(maxHeight: 150, maxWidth: 150),
                        child: Stack(children: [
                          pieChartWidget(percentCompleted.toDouble()),
                          Positioned(
                            top: 45,
                            left: 40,
                            child: Column(
                              children: [
                                Text("$percentCompleted%", style: textTheme.headlineLarge!.copyWith(color: colorGreen)),
                                Text("Completion", style: textTheme.labelLarge!.copyWith(color: colorGreen))
                              ],
                            )
                          ),
                        ]
                      )
                    ),
                    Spacer(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Time Remaining", style: textTheme.bodyLarge),
                        Text(
                          daysRemaining == 0 ? "Due Today!" : "$daysRemaining Day${daysRemaining == 1 ? "" : "s"}",
                          style: textTheme.titleMedium
                        ),
                        addHorizontalSpace(16),
                        TextButton(
                          onPressed: () => _navigateToDetailedGoalScreen(goal),
                          style: TextButton.styleFrom(
                            backgroundColor: colorGreyLight.withAlpha(180),
                            foregroundColor: colorBlack,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3)),
                            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                            minimumSize: Size(0, 0)
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text("See More", style: textTheme.labelMedium),
                              Icon(Icons.chevron_right, size: 16),
                            ],
                          ),
                        )
                      ],
                    ),
                  ]),
                ],
              )
            ],
          ),
        ],
      )
    );
  }

  Widget _calendarItem(TextTheme textTheme, DateTime date, int index, int numGoalsDue) {
    var isSelected = selectedCalendarIndex == index;

    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: colorBlack.withValues(alpha: isSelected ? 0 : 0.2),
            spreadRadius: 1,
            blurRadius: 6,
            offset: const Offset(0, 4),
          ),
        ],
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: isSelected ? colorGreen : colorGreenGradTop, width: 3),
        color: isSelected ? colorGreenGradTop : colorWhite,
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "${_getMonthName(date.month)}\n${date.day.toString()}",
              style: textTheme.labelLarge!.copyWith(color: isSelected ? colorWhite : colorGreenDark),
              textAlign: TextAlign.center,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Divider(color: isSelected ? colorWhite : colorGreenDark),
            ),
            Text(
              "$numGoalsDue Goal${numGoalsDue == 1 ? "" : "s"} Due",
              style: textTheme.bodySmall!.copyWith(color: isSelected ? colorWhite : colorGreenDark)
            )
          ],
        ),
      ),
    );
  }

  Widget pieChartWidget(double percentCompleted) {
    return LayoutBuilder(builder: (context, constraints) {
      return PieChart(
        PieChartData(
          sections: [
            PieChartSectionData(
              value: 100 - percentCompleted,
              title: "",
              color: Colors.grey[400],
              radius: constraints.maxHeight * 0.1
            ),
            PieChartSectionData(
              value: percentCompleted,
              title: "",
              color: colorGreenGradTop,
              radius: constraints.maxHeight * 0.1
            ),
          ], centerSpaceRadius: constraints.maxHeight * 0.4
        ),
      );
    });
  }

  String _getMonthName(int monthIdx) {
    return switch (monthIdx) {
      1 => "January",
      2 => "February",
      3 => "March",
      4 => "April",
      5 => "May",
      6 => "June",
      7 => "July",
      8 => "August",
      9 => "September",
      10 => "October",
      11 => "November",
      _ => "December",
    };
  }
}
