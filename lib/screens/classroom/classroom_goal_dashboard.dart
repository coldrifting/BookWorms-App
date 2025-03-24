import 'package:bookworms_app/resources/colors.dart';
import 'package:bookworms_app/utils/widget_functions.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ClassroomGoalDashboard extends StatefulWidget {
  const ClassroomGoalDashboard({super.key});

  @override
  State<ClassroomGoalDashboard> createState() => _ClassroomGoalDashboardState();
}

class _ClassroomGoalDashboardState extends State<ClassroomGoalDashboard> {
  late int numPages;
  late int selectedIndex;
  late DateTime currentDate;
  late PageController pageController;

  @override
  void initState() {
    super.initState();
    numPages = 13;
    selectedIndex = 6;
    currentDate = DateTime.now();
    pageController = PageController(initialPage: selectedIndex, viewportFraction: 0.3);
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Column(
      children: [
        SizedBox(
          height: 115,
          child: PageView.builder(
            controller: pageController,
            scrollDirection: Axis.horizontal,
            itemCount: numPages,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.only(left: 8.0, bottom: 12.0, right: 8.0),
                child: InkWell(
                  onTap: () { 
                    setState(() { 
                      selectedIndex = index;
                      pageController.animateToPage(
                        index,
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    });
                  },
                  child: _calendarItem(textTheme, currentDate.subtract(Duration(days: (numPages/2).toInt() - index)), index)
                ),
              );
            },
          ),
        ),
        Container(
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
          margin: const EdgeInsets.all(16.0),
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          height: 230,
          child: Stack(
            children: [
              Row(
                children: [
                  Column(
                    children: [
                      Text("Upcoming Goal", style: textTheme.titleMedium),
                      addVerticalSpace(8),
                      ConstrainedBox(
                        constraints: BoxConstraints(
                          maxHeight: 150,
                          maxWidth: 150
                        ),
                        child: Stack(
                          children: [
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
                    ],
                  ),
                  Spacer(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Time Remaining", style: textTheme.bodyLarge),
                      Text("X Days", style: textTheme.titleMedium),
                    ],
                  ),
                  addHorizontalSpace(16),
                ],
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: TextButton(
                  onPressed: () { },
                  style: TextButton.styleFrom(
                    backgroundColor: colorGreyLight!.withAlpha(180),
                    foregroundColor: colorBlack,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(3),
                    ),
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
              )
            ]
          ),
        ),
      ],
    );
  }

  Widget _calendarItem(TextTheme textTheme, DateTime date, int index) {
    var isSelected = selectedIndex == index;

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
        border: isSelected
          ? Border.all(color: colorGreen!, width: 3)
          : Border.all(color: colorWhite, width: 3),
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
            Text("0 Goals", style: textTheme.bodySmall!.copyWith(color: isSelected ? colorWhite : colorGreenDark))
          ],
        ),
      ),
    );
  }

  Widget pieChartWidget() {
    return LayoutBuilder(
      builder:(context, constraints) {
        return PieChart(
            PieChartData(
              sections: [
                PieChartSectionData(value: 10, title: "", color: Colors.grey[400], radius: constraints.maxHeight * 0.1),
                PieChartSectionData(value: 90, title: "", color: colorGreenGradTop, radius: constraints.maxHeight * 0.1),
              ],
              centerSpaceRadius: constraints.maxHeight * 0.4
            ),
          
        );
      }
    );
  }

  String _getMonthName(int monthIdx) {
    return switch(monthIdx) {
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