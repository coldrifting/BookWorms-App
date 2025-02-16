import 'package:http/http.dart' as http;

import 'package:bookworms_app/services/auth_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bookworms_app/resources/network.dart';
import 'package:bookworms_app/utils/http_helpers.dart';

class DeleteAccountService {
  final http.Client client;

  DeleteAccountService({http.Client? client}) : client = client ?? http.Client();

  Future<bool> deleteAccount(String username) async {
    final response = await client.sendRequest(
        uri: userDeleteUri,
        method: "DELETE");

    if (response.ok) {
      await deleteToken();
      SharedPreferences preferences = await SharedPreferences.getInstance();
      await preferences.remove('recentBookIds');
      return true;
    }
    else {
      throw Exception('An error occurred when trying to delete the user.');
    }
  }
}