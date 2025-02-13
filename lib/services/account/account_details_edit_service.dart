import 'package:bookworms_app/utils/http_client_ext.dart';
import 'package:bookworms_app/models/account_details.dart';
import 'package:bookworms_app/resources/network.dart';
import 'package:bookworms_app/utils/http_helpers.dart';

class AccountDetailsEditService {
  final HttpClientExt client;

  AccountDetailsEditService({HttpClientExt? client}) : client = client ?? HttpClientExt();

  // Modifies the first name, last name, or icon index of the account.
  Future<AccountDetails> setAccountDetails(String firstName, String lastName, int iconIndex) async {
    final response = await client.sendRequest(
        uri: userDetailsUri,
        method: "POST",
        payload: {
          "firstName": firstName,
          "lastName": lastName,
          "icon": iconIndex});

    if (response.ok) {
      return AccountDetails.fromJson(await readResponse(response));
    }
    else {
      throw Exception("An error occurred when editing the user account information.");
    }
  }
}