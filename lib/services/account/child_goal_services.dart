import 'dart:convert';
import 'package:bookworms_app/models/goals/child_goal.dart';
import 'package:bookworms_app/models/goals/goal.dart';
import 'package:bookworms_app/resources/network.dart';
import 'package:bookworms_app/utils/http_helpers.dart';
import 'package:http/http.dart' as http;

class ChildGoalService {
  final http.Client client;

  ChildGoalService({http.Client? client}) : client = client ?? http.Client();

  Future<List<ChildGoal>> getChildGoals(String childId) async {
    final response = await client.sendRequest(
      uri: getChildGoalsUri(childId),
      method: "GET"
    );

    if (response.ok) {
      final data = jsonDecode(response.body) as List;
      return data.map((goal) => ChildGoal.fromJson(goal)).toList();
    } else {
      throw Exception('An error occurred when getting the child\'s goals.');
    }
  }

  Future<ChildGoal> addChildGoal(Goal goal, String childId) async {
    final response = await client.sendRequest(
      uri: addChildGoalUri(childId),
      method: "POST",
      payload: {
        "goalType": goal.goalType,
        "goalMetric": goal.goalMetric,
        "title": goal.title,
        "startDate": goal.startDate,
        "endDate": goal.endDate,
        "target": goal.target
      }
    );

    if (response.ok) {
      final data = jsonDecode(response.body);
      return ChildGoal.fromJson(data);
    } else {
      throw Exception('An error occurred when adding the child goal.');
    }
  }

  Future<ChildGoal> getChildGoalDetails(String childId, String goalId) async {
    final response = await client.sendRequest(
      uri: getChildGoalDetailsUri(childId, goalId),
      method: "GET"
    );

    if (response.ok) {
      final data = jsonDecode(response.body);
      return ChildGoal.fromJson(data);
    } else {
      throw Exception('An error occurred when getting the child\'s goal details.');
    }
  }

  Future<bool> logChildGoal(String childId, String goalId, int progress) async {
    final response = await client.sendRequest(
      uri: logChildGoalProgressUri(childId, goalId, progress),
      method: "PUT"
    );
    
    if (response.ok) {
      return response.body == "true";
    } else {
      throw Exception('An error occurred when logging the child\'s progress.');
    }
  }

  Future<ChildGoal> editChildGoal(String childId, String goalId, String title, String startDate, String dueDate) async {
    final response = await client.sendRequest(
      uri: editChildGoalUri(childId, goalId),
      method: "PUT",
      payload: {
        "title": title,
        "startDate": startDate,
        "endDate": dueDate
      }
    );
    
    if (response.ok) {
      final data = jsonDecode(response.body);
      return ChildGoal.fromJson(data);
    } else {
      throw Exception('An error occurred when editing the child\'s goal.');
    }
  }

  Future<void> deleteChildGoal(String childId, String goalId) async {
    final response = await client.sendRequest(
      uri: deleteChildGoalUri(childId, goalId),
      method: "DELETE",
    );

    if (!response.ok) {
      throw Exception('An error occurred when deleting the child\'s goal.');
    }
  }
}
