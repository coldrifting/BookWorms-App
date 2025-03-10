import 'package:bookworms_app/models/goals/goal.dart';
import 'package:bookworms_app/models/goals/student_goal_status.dart';

enum ClassroomGoalType{ completion, numBooks }

class ClassroomGoal extends Goal {
  final ClassroomGoalType? type;
  final int studentsCompleted;
  final int totalStudents;
  final int? avgCompletionTime;
  final int? targetNumBooks;
  final int? avgBooksRead;
  final List<StudentGoalStatus>? studentGoalStatus;

  ClassroomGoal({
    required super.goalId, 
    required super.title, 
    required super.startDate, 
    required super.endDate, 
    required this.studentsCompleted, 
    required this.totalStudents, 
    this.type,
    this.avgCompletionTime, 
    this.targetNumBooks, 
    this.avgBooksRead,
    this.studentGoalStatus
  });

  factory ClassroomGoal.fromJson({required Map<String, dynamic> json, ClassroomGoalType? goalType}) {
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
      avgBooksRead: json['averageBooksRead'],
      studentGoalStatus: (json['studentGoalStatus'] as List)
        .map((goalStatus) => StudentGoalStatus.fromJson(goalStatus))
        .toList()
    );
  }
}