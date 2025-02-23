import 'dart:convert';
import 'package:bookworms_app/models/classroom/classroom.dart';
import 'package:bookworms_app/resources/network.dart';
import 'package:bookworms_app/utils/http_helpers.dart';
import 'package:http/http.dart' as http;

class ClassroomService {
  final http.Client client;

  ClassroomService({http.Client? client}) : client = client ?? http.Client();

  Future<Classroom> getClassroomDetails() async {
    final response = await client.sendRequest(
      uri: classroomDetailsUri(),
      method: "GET");

    if (response.ok) {
      final data = jsonDecode(response.body);
      return Classroom.fromJson(data);
    } else {
      throw Exception('An error occurred when getting the classroom details.');
    }
  }

  Future<Classroom> createClassroomDetails(String newClassroomName) async {
    final response = await client.sendRequest(
      uri: createClassroomUri(newClassroomName),
      method: "POST");

    if (response.ok) {
      final data = jsonDecode(response.body);
      return Classroom.fromJson(data);
    } else {
      throw Exception('An error occurred when creating the classroom.');
    }
  }
}