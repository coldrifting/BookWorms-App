import 'dart:convert';

import 'package:bookworms_app/models/classroom/classroom.dart';
import 'package:http/http.dart' as http;

import 'package:bookworms_app/models/child/child.dart';
import 'package:bookworms_app/resources/network.dart';
import 'package:bookworms_app/utils/http_helpers.dart';

class ChildrenServices {
  final http.Client client;

  ChildrenServices({http.Client? client}) : client = client ?? http.Client();

  Future<List<Child>> getChildren() async {
    final response = await client.sendRequest(
        uri: childrenAllUri,
        method: "GET");

    if (response.ok) {
      return await fromResponseListChild(response);
    }
    else {
      throw Exception('An error occurred when fetching children.');
    }
  }

  Future<Child> addChild(String childName) async {
    final response = await client.sendRequest(
        uri: childAddUri(childName),
        method: "POST");

    if (response.ok) {
      final List<Child> children = await fromResponseListChild(response);
      final String childId = getChildId(response);
      return children.singleWhere((val) => val.id == childId);
    }
    else {
      throw Exception('An error occurred when adding a child.');
    }
  }

  Future<Child> setAccountDetails(Child child, {String? newName, int? iconIndex}) async {
    final response = await client.sendRequest(
        uri: childEditDetailsUri(child.id),
        method: "PUT",
        payload: {
          "newName": newName,
          "childIcon": iconIndex
        }
      );

    if (response.ok) {
      return Child.fromJson(readResponse(response));
    }
    else {
      throw Exception("An error occurred when editing the child profile information.");
    }
  }

  Future<List<Classroom>> setChildClassrooms(String guid) async {
    final response = await client.sendRequest(
      uri: childClassroomsUri(guid),
      method: "GET");

    if (response.ok) {
      return await fromResponseListClassroom(response);
    }
    else {
      throw Exception('An error occurred when setting the child\'s classrooms.');
    }
  }

  Future<Classroom> joinChildClassroom(String guid, String classCode) async {
    final response = await client.sendRequest(
      uri: childJoinClassroomUri(guid, classCode),
      method: "POST");

    if (response.ok) {
      final data = jsonDecode(response.body);
      return Classroom.fromJson(data);
    }
    else {
      throw Exception('An error occurred when joining the classroom.');
    }
  }
}