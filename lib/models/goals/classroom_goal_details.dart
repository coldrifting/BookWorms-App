import 'package:bookworms_app/models/goals/student_goal_details.dart';

class ClassroomGoalDetails {
  final int studentsTotal;
  final int studentsCompleted;
  final List<StudentGoalDetails>? studentGoalDetails;

  ClassroomGoalDetails({
    required this.studentsTotal,
    required this.studentsCompleted,
    this.studentGoalDetails
  });

  factory ClassroomGoalDetails.fromJson({required Map<String, dynamic> json}) {
    return ClassroomGoalDetails(
      studentsTotal: json['studentsTotal'],
      studentsCompleted: json['studentsCompleted'],
      studentGoalDetails: json['studentGoalDetails'] != null
        ? (json['studentGoalDetails'] as List)
          .map((goalDetails) => StudentGoalDetails.fromJson(goalDetails))
          .toList()
        : null
    );
  }
}