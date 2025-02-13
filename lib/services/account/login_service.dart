import 'package:bookworms_app/models/user_login.dart';
import 'package:bookworms_app/utils/http_client_ext.dart';
import 'package:bookworms_app/services/auth_storage.dart';
import 'package:bookworms_app/resources/network.dart';
import 'package:bookworms_app/utils/http_helpers.dart';

/// The [LoginService] handles the login of a user by passing their credentials to the
/// server and obtaining a token if the credentials are valid.
class LoginService {
  final HttpClientExt client;

  LoginService({HttpClientExt? client}) : client = client ?? HttpClientExt();

  Future<bool> loginUser(String username, String password, Function(String) onValidationError) async {
    final response = await client.sendRequest(
        uri: userLoginUri,
        method: "POST",
        payload: {
          "username": username,
          "password": password});

    final UserLogin userLogin = UserLogin.fromJson(await readResponse(response));

    String fieldError = "";

    if (response.ok) {
      await saveToken(userLogin.token);
      return true;
    }
    else { // Bad Request (Invalid username/password)
      fieldError = "Incorrect username and/or password.";
    }

    onValidationError(fieldError);
    return false;
  }
}