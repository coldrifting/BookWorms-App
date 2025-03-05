import 'package:bookworms_app/models/goals/goal.dart';

class ClassroomCompletionGoal extends Goal {
  final int studentsCompleted;
  final int totalStudents;
  final int avgCompletionTime;

  ClassroomCompletionGoal({
    required super.goalId,
    required super.title,
    required super.startDate,
    required super.endDate,
    required this.studentsCompleted,
    required this.totalStudents,
    required this.avgCompletionTime
  });

  factory ClassroomCompletionGoal.fromJson(Map<String, dynamic> json) {
    return ClassroomCompletionGoal(
      goalId: json['goalId'],
      title: json['title'],
      startDate: json['startDate'],
      endDate: json['endDate'],
      studentsCompleted: json['progress'],
      totalStudents: json['duration'],
      avgCompletionTime: json['avgCompletionTime']
    );
  }
}

class ClassroomNumBookGoal extends Goal {
  final int studentsCompleted;
  final int totalStudents;
  final int targetNumBooks;
  final int avgBooksRead;

  ClassroomNumBookGoal({
    required super.goalId,
    required super.title,
    required super.startDate,
    required super.endDate,
    required this.studentsCompleted,
    required this.totalStudents,
    required this.targetNumBooks,
    required this.avgBooksRead
  });

  factory ClassroomNumBookGoal.fromJson(Map<String, dynamic> json) {
    return ClassroomNumBookGoal(
      goalId: json['goalId'],
      title: json['title'],
      startDate: json['startDate'],
      endDate: json['endDate'],
      studentsCompleted: json['studentsCompleted'],
      totalStudents: json['totalStudents'],
      targetNumBooks: json['targetNumBooks'],
      avgBooksRead: json['avgerageBooksRead']
    );
  }
}