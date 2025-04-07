import 'package:bookworms_app/resources/colors.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

// Calculates the percentage of time between the start date, now, and the end date.
Widget completionBarWidget(int numStudentsCompleted, int numTotalStudents) {
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