import 'package:bookworms_app/models/goals/goal.dart';


class ChildGoal extends Goal {
  ChildGoal({
    required super.goalId, 
    required super.goalType,
    required super.goalMetric,
    required super.title, 
    required super.startDate, 
    required super.endDate,
    required super.target,
    required super.progress
  });

  factory ChildGoal.fromJson(Map<String, dynamic> json) {
    return ChildGoal(
      goalId: json['goalId'],
      goalType: json['goalType'],
      goalMetric: json['goalMetric'],
      title: json['title'],
      startDate: json['startDate'],
      endDate: json['endDate'],
      target: json['target'],
      progress: json['progress'],
    );
  }
}