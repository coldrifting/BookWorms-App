import 'package:bookworms_app/models/goals/goal.dart';


class ChildGoal extends Goal {
  // final int? duration;
  // final int? targetNumBooks;
  // final int? numBooks;
  // final String? className;
  // final String? classCode;

  ChildGoal({
    required super.goalId, 
    required super.goalType,
    required super.goalMetric,
    required super.title, 
    required super.startDate, 
    required super.endDate,
    required super.target,
    required super.progress


    // this.duration, 
    // this.targetNumBooks, 
    // this.numBooks, 
    // this.className, 
    // this.classCode, 
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
      // duration: json['duration'],
      // targetNumBooks: json['targetNumBooks'],
      // numBooks: json['numBooks'],
      // className: json['className'],
      // classCode: json['classCode'],
    );
  }
}