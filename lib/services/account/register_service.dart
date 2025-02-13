import 'package:bookworms_app/models/user_login.dart';
import 'package:bookworms_app/utils/http_client_ext.dart';
import 'package:bookworms_app/models/error_validation.dart';
import 'package:bookworms_app/services/auth_storage.dart';
import 'package:bookworms_app/models/error_basic.dart';
import 'package:bookworms_app/resources/network.dart';
import 'package:bookworms_app/utils/http_helpers.dart';

/// The [RegisterService] handles the registration of a user by passing their inputted
/// data and credentials to the server and obtaining a token for the new user.
class RegisterService {
  final HttpClientExt client;

  RegisterService({HttpClientExt? client}) : client = client ?? HttpClientExt();

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

    Map<String, String> fieldErrors = {};

    if (response.ok) {
      // Success
      final UserLogin userLogin = UserLogin.fromJson(await readResponse(response));
      await saveToken(userLogin.token);
      return true;
    }
    else if (response.statusCode == 400) {
      // Bad Request (problem with name or password).
      final ErrorValidation data = ErrorValidation.fromJson(await readResponse(response));
      data.errors.forEach((String field, List<String> errorDescArr) {
        if (errorDescArr.isNotEmpty) {
          fieldErrors[field] = errorDescArr.join(" ");
        }
      });
    }
    else {
      // Unprocessable entity (username exists).
      final ErrorBasic data = ErrorBasic.fromJson(await readResponse(response));
      fieldErrors["Username"] = data.description;
    }
    onValidationError(fieldErrors);
    return false;
  }
}
