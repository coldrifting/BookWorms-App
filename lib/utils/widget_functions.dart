import 'package:flutter/material.dart';

// Creates a SizedBox widget with specified height.
Widget addVerticalSpace(double height) {
  return SizedBox(height: height);
}

// Creates a SizedBox widget with specified width.
Widget addHorizontalSpace(double width) {
  return SizedBox(width: width);
}

void pushScreen(context, screen) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => screen
    )
  );
}