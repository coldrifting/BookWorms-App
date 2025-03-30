import 'package:bookworms_app/models/goals/classroom_goal_details.dart';
import 'package:bookworms_app/models/goals/goal.dart';

class ClassroomGoal extends Goal {
  final ClassroomGoalDetails? classGoalDetails;

  ClassroomGoal({
    required super.goalId, 
    required super.goalType,
    required super.goalMetric,
    required super.title, 
    required super.startDate, 
    required super.endDate, 
    required super.target,
    required super.progress,
    this.classGoalDetails
  });

  factory ClassroomGoal.fromJson({required Map<String, dynamic> json}) {
    return ClassroomGoal(
      goalId: json['goalId'],
      goalType: json['goalType'],
      goalMetric: json['goalMetric'],
      title: json['title'],
      startDate: json['startDate'],
      endDate: json['endDate'],
      target: json['target'],
      progress: json['progress'],
      classGoalDetails: json['classGoalDetails'] != null
        ? ClassroomGoalDetails.fromJson(json: json['classGoalDetails'])
        : null
    );
  }
}