import 'package:bookworms_app/utils/http_client_ext.dart';
import 'package:bookworms_app/services/auth_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bookworms_app/resources/network.dart';
import 'package:bookworms_app/utils/http_helpers.dart';

class DeleteAccountService {
  final HttpClientExt client;

  DeleteAccountService({HttpClientExt? client}) : client = client ?? HttpClientExt();

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