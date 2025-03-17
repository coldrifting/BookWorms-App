import 'dart:convert';
import 'package:bookworms_app/models/goals/classroom_goal.dart';
import 'package:bookworms_app/resources/network.dart';
import 'package:bookworms_app/utils/http_helpers.dart';
import 'package:http/http.dart' as http;

class ClassroomGoalsService {
  final http.Client client;

  ClassroomGoalsService({http.Client? client}) : client = client ?? http.Client();

  Future<List<ClassroomGoal>> getClassroomGoals() async {
    final response = await client.sendRequest(
      uri: getClassroomGoalsUri(),
      method: "GET"
    );

    if (response.ok) {
      final data = jsonDecode(response.body) as List;
      return data.map((goal) => ClassroomGoal.fromJson(json: goal)).toList();
    } else {
      throw Exception('An error occurred when getting the classroom goals.');
    }
  }

  Future<ClassroomGoal> addClassroomGoal(String title, String endDate, int? targetNumBooks) async {
    final response = await client.sendRequest(
      uri: addClassroomGoalUri(),
      method: "POST",
      payload: {
        "title": title,
        "endDate": endDate,
        if (targetNumBooks != null) "targetNumBooks": targetNumBooks,
      }
    );

    if (response.ok) {
      final data = jsonDecode(response.body);
      return ClassroomGoal.fromJson(json: data);
    } else {
      throw Exception('An error occurred when adding the classroom goal.');
    }
  }

  Future<ClassroomGoal> getClassroomGoalStudentDetails(String goalId) async {
    final response = await client.sendRequest(
      uri: getClassroomGoalStudentDetailsUri(goalId),
      method: "GET"
    );

    if (response.ok) {
      final data = jsonDecode(response.body);
      return ClassroomGoal.fromJson(json: data);
    } else {
      throw Exception('An error occurred when getting the classroom student goal details.');
    }
  }

  Future<ClassroomGoal> editClassroomGoal(String goalId, String? newTitle, String? newEndDate, int? newTargetNumBooks) async {
    final response = await client.sendRequest(
      uri: editClassroomGoalUri(goalId),
      method: "PUT",
      payload: {
        if (newTitle != null) "newTitle": newTitle,
        if (newEndDate != null) "newEndDate": newEndDate,
        if (newTargetNumBooks != null) "newTargetNumBooks": newTargetNumBooks
      }
    );
    
    if (response.ok) {
      final data = jsonDecode(response.body);
      return ClassroomGoal.fromJson(json: data);
    } else {
      throw Exception('An error occurred when editing the classroom goal.');
    }
  }

  Future<void> deleteClassroomGoal(String goalId) async {
    final response = await client.sendRequest(
      uri: deleteClassroomGoalUri(goalId),
      method: "DELETE",
    );

    if (response.ok) {
      return;
    } else {
      throw Exception('An error occurred when deleting the classroom goal.');
    }
  }
}

