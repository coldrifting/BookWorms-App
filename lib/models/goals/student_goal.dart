import 'dart:ffi';
import 'package:bookworms_app/models/goals/goal.dart';
import 'package:bookworms_app/resources/constants.dart';

class CompletionGoal extends Goal {
  final GoalType type;
  final Float progress;
  final int duration;

  CompletionGoal({
    required super.goalId,
    required this.type,
    required super.title,
    required super.startDate,
    required super.endDate,
    required this.progress,
    required this.duration,
  });

  factory CompletionGoal.fromJson(Map<String, dynamic> json) {
    return CompletionGoal(
      goalId: json['goalId'],
      type: json['type'],
      title: json['title'],
      startDate: json['startDate'],
      endDate: json['endDate'],
      progress: json['progress'],
      duration: json['duration'],
    );
  }
}

class NumBookGoal extends Goal {
  final GoalType type;
  final int targetNumBooks;
  final int numBooks;

  NumBookGoal({
    required super.goalId,
    required this.type,
    required super.title,
    required super.startDate,
    required super.endDate,
    required this.targetNumBooks,
    required this.numBooks,
  });

  factory NumBookGoal.fromJson(Map<String, dynamic> json) {
    return NumBookGoal(
      goalId: json['goalId'],
      type: json['type'],
      title: json['title'],
      startDate: json['startDate'],
      endDate: json['endDate'],
      targetNumBooks: json['targetNumBooks'],
      numBooks: json['numBooks'],
    );
  }
}

class ClassCompletionGoal extends CompletionGoal {
  final String className;
  final String classCode;

  ClassCompletionGoal({
    required super.goalId,
    required super.type,
    required super.title,
    required super.startDate,
    required super.endDate,
    required super.progress,
    required super.duration,
    required this.className,
    required this.classCode,
  });

  factory ClassCompletionGoal.fromJson(Map<String, dynamic> json) {
    return ClassCompletionGoal(
      goalId: json['goalId'],
      type: json['type'],
      title: json['title'],
      startDate: json['startDate'],
      endDate: json['endDate'],
      progress: json['progress'],
      duration: json['duration'],
      className: json['className'],
      classCode: json['classCode'],
    );
  }
}

class ClassNumBooksGoal extends NumBookGoal {
  final String className;
  final String classCode;

  ClassNumBooksGoal({
    required super.goalId,
    required super.type,
    required super.title,
    required super.startDate,
    required super.endDate,
    required super.targetNumBooks,
    required super.numBooks,
    required this.className,
    required this.classCode,
  });

  factory ClassNumBooksGoal.fromJson(Map<String, dynamic> json) {
    return ClassNumBooksGoal(
      goalId: json['goalId'],
      type: json['type'],
      title: json['title'],
      startDate: json['startDate'],
      endDate: json['endDate'],
      targetNumBooks: json['targetNumBooks'],
      numBooks: json['numBooks'],
      className: json['className'],
      classCode: json['classCode'],
    );
  }
}
