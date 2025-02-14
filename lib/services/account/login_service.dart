import 'dart:convert';
import 'package:bookworms_app/services/auth_storage.dart';
import 'package:bookworms_app/services/services_shared.dart';
import 'package:http/http.dart' as http;

/// The [LoginService] handles the login of a user by passing their credentials to the
/// server and obtaining a token if the credentials are valid.
class LoginService {
  final http.Client client;

  LoginService({http.Client? client}) : client = client ?? http.Client();

  Future<bool> loginUser(String username, String password, Function(String) onValidationError) async {
    final response = await client.post(
      Uri.parse('${ServicesShared.serverAddress}/user/login'),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json'
      },
      body: json.encode({
        "username": username,
        "password": password
      })
    );

    String fieldError = "";

    if (response.statusCode == 200 || response.statusCode == 201) { // Success
      final data = jsonDecode(response.body);
      saveToken(data["token"]);
      return true;
    } else if (response.statusCode == 400) { // Bad Request (Invalid username/password)
      fieldError = "Incorrect username and/or password.";
    }
    onValidationError(fieldError);
    return false;
  }
}