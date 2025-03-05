import 'dart:convert';
import 'package:bookworms_app/models/child/student_goal.dart';
import 'package:bookworms_app/resources/network.dart';
import 'package:bookworms_app/utils/http_helpers.dart';
import 'package:http/http.dart' as http;

class ClassroomGoalsService {
  final http.Client client;

  ClassroomGoalsService({http.Client? client}) : client = client ?? http.Client();

  Future<ClassroomGoal?> getClassroomGoals() async {
    final response = await client.sendRequest(
      uri: getClassroomGoalsUri(),
      method: "GET");

    if (response.ok) {
      final data = jsonDecode(response.body);
      return ClassroomGoal.fromJson(data);
    } else if (response.statusCode == 404) {
      return null;
    } else {
      throw Exception('An error occurred when getting the classroom goals.');
    }
  }
}