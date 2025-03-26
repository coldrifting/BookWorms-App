import 'package:bookworms_app/app_state.dart';
import 'package:bookworms_app/models/goals/classroom_goal.dart';
import 'package:bookworms_app/resources/colors.dart';
import 'package:bookworms_app/screens/classroom/class_goal_details.dart';
import 'package:bookworms_app/utils/widget_functions.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ClassroomGoalDashboard extends StatefulWidget {
  const ClassroomGoalDashboard({super.key});

  @override
  State<ClassroomGoalDashboard> createState() => _ClassroomGoalDashboardState();
}

class _ClassroomGoalDashboardState extends State<ClassroomGoalDashboard> {
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

    final goals = appState.classroom!.classroomGoals;
    final activeGoals = _getActiveGoals(goals);

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
                    index
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

              return Padding(
                padding: EdgeInsets.only(bottom: 12.0),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ClassGoalDetails(goal: activeGoals[selectedCalendarIndex][index])
                      ),
                    );
                  },
                  child: _goalItem(
                    textTheme, 
                    activeGoals[selectedCalendarIndex][index], 
                    selectedDate
                  )
                )
              );
            },
          )
          : _noGoalsWidget()
        ),
      ],
    );
  }

  // Returns the list of currently-active goals.
  List<List<ClassroomGoal>> _getActiveGoals(List<ClassroomGoal> allGoals) {
    return List.generate(_numPages, (i) {
      final now = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
      final date = now.add(Duration(days: i - _initialCalendarIndex));

      final goalsForDate = allGoals.where((goal) {
        final start = DateTime.parse(goal.startDate);
        final end = DateTime.parse(goal.endDate);
        final startDate = DateTime(start.year, start.month, start.day);
        final endDate = DateTime(end.year, end.month, end.day);
        return !date.isBefore(startDate) && !date.isAfter(endDate);
      }).toList();

      goalsForDate.sort((a, b) => a.endDate.compareTo(b.endDate));
      return goalsForDate;
    });
  }

  // "No goals to show" display.
  Widget _noGoalsWidget() {
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
      width: 375,
      child: Center(
        child: Text(
          "No goals to show.\nHave a nice day!",
          textAlign: TextAlign.center
        )
      )
    );
  }

  Widget _goalItem(TextTheme textTheme, ClassroomGoal goal, DateTime date) {
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
              Text(goal.title, style: textTheme.titleMedium),
              Column(
                children: [
                  Row(children: [
                    addVerticalSpace(8),
                    ConstrainedBox(
                        constraints: BoxConstraints(maxHeight: 150, maxWidth: 150),
                        child: Stack(children: [
                          pieChartWidget(),
                          Positioned(
                            top: 45,
                            left: 40,
                            child: Column(
                              children: [
                                Text("90%", style: textTheme.headlineLarge!.copyWith(color: colorGreen)),
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
                          onPressed: () {},
                          style: TextButton.styleFrom(
                            backgroundColor: colorGreyLight!.withAlpha(180),
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

  Widget _calendarItem(TextTheme textTheme, DateTime date, int index) {
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
        border: Border.all(color: isSelected ? colorGreen! : colorGreenGradTop, width: 3),
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
              "0 Goals Due",
              style: textTheme.bodySmall!.copyWith(color: isSelected ? colorWhite : colorGreenDark)
            )
          ],
        ),
      ),
    );
  }

  Widget pieChartWidget() {
    return LayoutBuilder(builder: (context, constraints) {
      return PieChart(
        PieChartData(
          sections: [
            PieChartSectionData(
              value: 10,
              title: "",
              color: Colors.grey[400],
              radius: constraints.maxHeight * 0.1
            ),
            PieChartSectionData(
              value: 90,
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
