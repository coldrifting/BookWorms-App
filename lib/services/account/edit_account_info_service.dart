import 'dart:convert';
import 'package:bookworms_app/models/account_details.dart';
import 'package:bookworms_app/services/auth_storage.dart';
import 'package:bookworms_app/services/services_shared.dart';
import 'package:http/http.dart' as http;

class EditAccountInfoService {
  final http.Client client;

  EditAccountInfoService({http.Client? client}) : client = client ?? http.Client();

  // Modifies the first name, last name, or icon index of the account.
  Future<AccountDetails> setAccountDetails(String firstName, String lastName, int iconIndex) async {
    final response = await client.put(
      Uri.parse('http://${ServicesShared.serverAddress}/user/details'),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${await getToken()}'
      },
      body: json.encode({
        "firstName": firstName,
        "lastName": lastName,
        "icon": iconIndex,
      })
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return AccountDetails.fromJson(data);
    } else {
      throw Exception("An error occurred when editing the user account information.");
    }
  }
}