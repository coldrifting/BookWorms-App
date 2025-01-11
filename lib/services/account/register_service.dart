import 'dart:convert';
import 'package:bookworms_app/services/auth_storage.dart';
import 'package:bookworms_app/services/services_shared.dart';
import 'package:http/http.dart' as http;

/// The [RegisterService] handles the registration of a user by passing their inputted 
/// data and credentials to the server and obtaining a token for the new user.
class RegisterService {
  final http.Client client;

  RegisterService({http.Client? client}) : client = client ?? http.Client();

  Future<void> registerUser(String username, String password, String firstName, String lastName) async {
    final response = await client.post(
      Uri.parse('http://${ServicesShared.serverAddress}/user/register'),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json'
      },
      body: json.encode({
        "username": username,
        "password": password,
        "firstName": firstName,
        "lastName": lastName
      })
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body);
      // Save the token to the secure storage. 
      saveToken(data["token"]);
    } else {
      throw Exception('An error occurred when registering the user.');
    }
  }
}