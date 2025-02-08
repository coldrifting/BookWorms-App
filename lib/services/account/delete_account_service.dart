import 'dart:convert';

import 'package:bookworms_app/services/auth_storage.dart';
import 'package:bookworms_app/services/services_shared.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class DeleteAccountService {
  final http.Client client;

  DeleteAccountService({http.Client? client}) : client = client ?? http.Client();

  Future<bool> deleteAccount(String username) async {
    final response = await client.delete(
      Uri.parse('http://${ServicesShared.serverAddress}/user/delete'),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${await getToken()}'
      },
      body: json.encode({ "username": username }),
    );
    if (response.statusCode == 204) {
      deleteToken();
      SharedPreferences preferences = await SharedPreferences.getInstance();
      await preferences.remove('recentBookIds');
      return true;
    } else {
      throw Exception('An error occurred when trying to delete the user.');
    }
  }
}