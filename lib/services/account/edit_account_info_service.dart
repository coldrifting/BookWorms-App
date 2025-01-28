import 'dart:convert';
import 'package:bookworms_app/services/auth_storage.dart';
import 'package:bookworms_app/services/services_shared.dart';
import 'package:http/http.dart' as http;

class EditAccountInfoService {
  final http.Client client;

  EditAccountInfoService({http.Client? client}) : client = client ?? http.Client();

  // Modifies the first name, last name, or icon index of the account.
  Future<bool> setAccountDetails(String firstName, String lastName, int iconIndex) async {
    final response = await client.post(
      Uri.parse('http://${ServicesShared.serverAddress}/user/edit'),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${await getToken()}'
      },
      body: json.encode({
        "firstName": firstName,
        "lastName": lastName,
        //"icon": iconIndex,
      })
    );
    return response.statusCode == 200;
  }
}