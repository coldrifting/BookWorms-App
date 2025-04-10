import 'package:bookworms_app/resources/theme.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

// Calculates the percentage of time between the start date, now, and the end date.
Widget completionBarWidget(BuildContext context, int numStudentsCompleted, int numTotalStudents) {
    double percentCompleted = numTotalStudents == 0 ? 0.0 : numStudentsCompleted / numTotalStudents;
    Color barColor;
    if (percentCompleted < 0.5) {
      barColor = context.colors.progressLow;
    } else if (percentCompleted < 0.9) {
      barColor = context.colors.progressMedium;
    } else {
      barColor = context.colors.progressComplete;
    }

    return LinearPercentIndicator(
      lineHeight: 8.0,
      percent: percentCompleted,
      progressColor: barColor,
      barRadius: const Radius.circular(4),
      backgroundColor: context.colors.progressBackground,
    );
  }