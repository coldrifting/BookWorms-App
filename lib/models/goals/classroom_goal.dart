import 'package:bookworms_app/models/goals/goal.dart';

enum ClassroomGoalType{ completion, numBooks }

class ClassroomGoal extends Goal {
  final ClassroomGoalType? type;
  final int studentsCompleted;
  final int totalStudents;
  final int? avgCompletionTime;
  final int? targetNumBooks;
  final int? avgBooksRead;

  ClassroomGoal({
    required super.goalId, 
    required super.title, 
    required super.startDate, 
    required super.endDate, 
    required this.type,
    required this.studentsCompleted, 
    required this.totalStudents, 
    this.avgCompletionTime, 
    this.targetNumBooks, 
    this.avgBooksRead
  });

  factory ClassroomGoal.fromJson(Map<String, dynamic> json, ClassroomGoalType goalType) {
    return ClassroomGoal(
      goalId: json['goalId'],
      title: json['title'],
      startDate: json['startDate'],
      endDate: json['endDate'],
      type: goalType,
      studentsCompleted: json['studentsCompleted'],
      totalStudents: json['totalStudents'],
      avgCompletionTime: json['averageCompletionTime'],
      targetNumBooks: json['targetNumBooks'],
      avgBooksRead: json['averageBooksRead']
    );
  }
}