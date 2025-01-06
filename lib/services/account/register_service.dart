import 'dart:convert';
import 'package:bookworms_app/models/account.dart';
import 'package:bookworms_app/services/services_shared.dart';
import 'package:http/http.dart' as http;

class RegisterService {
  final http.Client client;

  RegisterService({http.Client? client}) : client = client ?? http.Client();

  Future<Account> register(String username, String password, String name, String email) async {
    final response = await client.post(
      Uri.parse('http://${ServicesShared.serverAddress}/user/register'),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json'
      },
      body: json.encode({
        "username": username,
        "password": password,
        "name": name,
        "email": email
      })
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body);
      return Account.fromJson(data);
    } else {
      throw Exception('An error occurred when registering the user.');
    }
  }
}