import 'dart:convert';
import 'package:bookworms_app/models/child.dart';
import 'package:bookworms_app/services/auth_storage.dart';
import 'package:bookworms_app/services/services_shared.dart';
import 'package:http/http.dart' as http;

class AddChildService {
  final http.Client client;

  AddChildService({http.Client? client}) : client = client ?? http.Client();

  Future<Child> addChild(String childName) async {
    final response = await client.post(
      Uri.parse('http://${ServicesShared.serverAddress}/children/add?childName=$childName'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer ${await getToken()}'
      },
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body);
      return Child.fromJson(data);
    } else {
      throw Exception('An error occurred when adding a child.');
    }
  }
}