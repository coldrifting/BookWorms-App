import 'package:flutter/material.dart';

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