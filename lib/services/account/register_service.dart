import 'package:http/http.dart' as http;

import 'package:bookworms_app/models/user_login.dart';
import 'package:bookworms_app/models/error_validation.dart';
import 'package:bookworms_app/services/auth_storage.dart';
import 'package:bookworms_app/models/error_basic.dart';
import 'package:bookworms_app/resources/network.dart';
import 'package:bookworms_app/utils/http_helpers.dart';

/// The [RegisterService] handles the registration of a user by passing their inputted
/// data and credentials to the server and obtaining a token for the new user.
class RegisterService {
  final http.Client client;

  RegisterService({http.Client? client}) : client = client ?? http.Client();

  Future<bool> registerUser(
      String username,
      String password,
      String firstName,
      String lastName,
      bool isParent,
      Function(Map<String, String>) onValidationError) async {
    final response = await client.sendRequest(
        uri: userRegisterUri,
        method: "POST",
        payload: {
          "username": username,
          "password": password,
          "firstName": firstName,
          "lastName": lastName,
          "isParent": isParent});

    final Map<String, String> fieldErrors = {};
    final Map<String, dynamic>mappedResponse = readResponse(response);

    if (response.ok) {
      // Success
      final UserLogin userLogin = UserLogin.fromJson(mappedResponse);
      await saveToken(userLogin.token);
      return true;
    }
    else if (response.badRequest) {
      // Bad Request (problem with name or password).
      final ErrorValidation data = ErrorValidation.fromJson(mappedResponse);
      data.errors.forEach((String field, List<String> errorDescArr) {
        if (errorDescArr.isNotEmpty) {
          fieldErrors[field] = errorDescArr.join(" ");
        }
      });
    }
    else {
      // Unprocessable entity (username exists).
      final ErrorBasic data = ErrorBasic.fromJson(mappedResponse);
      fieldErrors["Username"] = data.description;
    }
    onValidationError(fieldErrors);
    return false;
  }
}
