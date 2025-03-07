import 'package:bookworms_app/models/goals/goal.dart';

enum StudentGoalType { 
  completion, 
  numBook, 
  classCompletion, 
  classNumBook
}

class StudentGoal extends Goal {
  final StudentGoalType type;
  final double? progress;
  final int? duration;
  final int? targetNumBooks;
  final int? numBooks;
  final String? className;
  final String? classCode;

  StudentGoal({
    required super.goalId, 
    required super.title, 
    required super.startDate, 
    required super.endDate,
    required this.type, 
    this.progress, 
    this.duration, 
    this.targetNumBooks, 
    this.numBooks, 
    this.className, 
    this.classCode, 
  });

  factory StudentGoal.fromJson(Map<String, dynamic> json, StudentGoalType goalType) {
    return StudentGoal(
      goalId: json['goalId'],
      title: json['title'],
      startDate: json['startDate'],
      endDate: json['endDate'],
      type: goalType,
      progress: json['progress'],
      duration: json['duration'],
      targetNumBooks: json['targetNumBooks'],
      numBooks: json['numBooks'],
      className: json['className'],
      classCode: json['classCode'],
    );
  }
}