import 'dart:convert';
import 'package:bookworms_app/models/goals/classroom_goal.dart';
import 'package:bookworms_app/resources/network.dart';
import 'package:bookworms_app/utils/http_helpers.dart';
import 'package:http/http.dart' as http;

class ClassroomGoalsService {
  final http.Client client;

  ClassroomGoalsService({http.Client? client}) : client = client ?? http.Client();

  Future<List<ClassroomGoal>?> getClassroomGoals() async {
    final response = await client.sendRequest(
      uri: getClassroomGoalsUri(),
      method: "GET"
    );

    if (response.ok) {
      final data = jsonDecode(response.body);
      List<ClassroomGoal> goals = [];

      // Parse completion goals.
      if (data.containsKey("completionGoals")) {
        goals.addAll(
          (data["completionGoals"] as List).map(
            (goal) => ClassroomGoal.fromJson(goal, ClassroomGoalType.completion),
          ),
        );
      }

      // Parse numBook goals.
      if (data.containsKey("numBookGoals")) {
        goals.addAll(
          (data["numBookGoals"] as List).map(
            (goal) => ClassroomGoal.fromJson(goal, ClassroomGoalType.numBooks),
          ),
        );
      }
      return goals;
    } else if (response.statusCode >= 400 && response.statusCode < 500) {
      return null;
    } else {
      throw Exception('An error occurred when getting the classroom goals.');
    }
  }

  Future<ClassroomGoal?> addClassroomGoal(String title, String endDate, {int? targetNumBooks}) async {
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
      ClassroomGoalType newGoalType = targetNumBooks == null ? ClassroomGoalType.completion : ClassroomGoalType.numBooks;
      return ClassroomGoal.fromJson(data, newGoalType);
    } else if (response.statusCode >= 400 && response.statusCode < 500) {
      return null;
    } else {
      throw Exception('An error occurred when adding the classroom goal.');
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

