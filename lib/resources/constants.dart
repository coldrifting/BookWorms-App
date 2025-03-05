import 'package:flutter/material.dart';

// A goal has a type of 'child' or 'classroom'.
enum GoalType {
  child(),
  classroom();
}

// Bookshelf type to define the bookshelf color.
enum BookshelfType {
  completed("Completed", Colors.green),
  inProgress("InProgress", Colors.lightBlue),
  custom("Custom", Colors.grey),
  classroom("Classroom", Colors.red);

  final MaterialColor color;
  final String name;
  const BookshelfType(this.name, this.color);

  Color operator [](int shade) {
    return color[shade]!;
  }
}

final List<Color> classroomColors = [
  Colors.pink,
  Colors.red,
  Colors.orange,
  Colors.amber,
  Colors.lightGreen,
  Colors.green,
  Colors.lightBlue,
  Colors.blue,
  Colors.purple,
  Colors.brown,
  Colors.black
];