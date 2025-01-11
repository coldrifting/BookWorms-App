import 'dart:convert';
import 'package:bookworms_app/services/auth_storage.dart';
import 'package:bookworms_app/services/services_shared.dart';
import 'package:http/http.dart' as http;

class LoginService {
  final http.Client client;

  LoginService({http.Client? client}) : client = client ?? http.Client();

  Future<void> register(String username, String password) async {
    final response = await client.post(
      Uri.parse('http://${ServicesShared.serverAddress}/user/login'),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json'
      },
      body: json.encode({
        "username": username,
        "password": password
      })
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body);
      saveToken(data["token"]);
    } else {
      throw Exception('An error occurred when registering the user.');
    }
  }
}