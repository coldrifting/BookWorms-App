import 'package:bookworms_app/models/goals/completion_goal.dart';
import 'package:bookworms_app/models/goals/goal.dart';
import 'package:bookworms_app/models/goals/num_books_goal.dart';
import 'package:bookworms_app/models/goals/student_goal_status.dart';

enum ClassroomGoalType{ completion, numBooks }

class ClassroomGoal extends Goal {
  final int studentsCompleted;
  final int totalStudents;
  final CompletionGoal? completionGoal;
  final NumBooksGoal? numBooksGoal;
  final List<StudentGoalStatus>? studentGoalStatus;

  ClassroomGoal({
    required super.goalId, 
    required super.title, 
    required super.startDate, 
    required super.endDate, 
    required this.studentsCompleted, 
    required this.totalStudents, 
    this.completionGoal,
    this.numBooksGoal,
    this.studentGoalStatus
  });

  factory ClassroomGoal.fromJson({required Map<String, dynamic> json}) {
    return ClassroomGoal(
      goalId: json['goalId'],
      title: json['title'],
      startDate: json['startDate'],
      endDate: json['endDate'],
      studentsCompleted: json['studentsCompleted'],
      totalStudents: json['totalStudents'],
      completionGoal: json['completionGoalData'] != null 
        ? CompletionGoal.fromJson(json['completionGoalData'])
        : null,
      numBooksGoal: json['numBooksGoalData'] != null
        ? NumBooksGoal.fromJson(json['numBooksGoalData'])
        : null,
      studentGoalStatus: json['studentGoalStatus'] != null
        ? (json['studentGoalStatus'] as List)
          .map((goalStatus) => StudentGoalStatus.fromJson(goalStatus))
          .toList()
        : null
    );
  }
}