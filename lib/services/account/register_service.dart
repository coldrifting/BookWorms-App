import 'dart:convert';
import 'package:bookworms_app/services/auth_storage.dart';
import 'package:bookworms_app/services/services_shared.dart';
import 'package:http/http.dart' as http;

/// The [RegisterService] handles the registration of a user by passing their inputted 
/// data and credentials to the server and obtaining a token for the new user.
class RegisterService {
  final http.Client client;

  RegisterService({http.Client? client}) : client = client ?? http.Client();

  Future<bool> registerUser(String username, String password, String firstName, String lastName, 
      bool isParent, Function(Map<String,String>) onValidationError) async {
    final response = await client.post(
      Uri.parse('${ServicesShared.serverAddress}/user/register'),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json'
      },
      body: json.encode({
        "username": username,
        "password": password,
        "firstName": firstName,
        "lastName": lastName,
        "isParent": isParent
      })
    );

    Map<String, String> fieldErrors = {};

    if (response.statusCode == 200 || response.statusCode == 201) { // Success
      final data = jsonDecode(response.body);
      saveToken(data["token"]);
      return true;
    } else if (response.statusCode == 400) { // Bad Request (problem with name or password).
      final data = jsonDecode(response.body);

      if (data.containsKey("errors")) {        
        data["errors"].forEach((key, value) {
          if (value is List && value.isNotEmpty) {
            fieldErrors[key] = value.join(" ");
          }
        });
      }
    } else if (response.statusCode == 422) { // Unprocessable entity (username exists).
      final data = jsonDecode(response.body);
      if (data.containsKey("description")) {
        fieldErrors["Username"] = data["description"];
      }
    }
    onValidationError(fieldErrors);
    return false;
  }
}