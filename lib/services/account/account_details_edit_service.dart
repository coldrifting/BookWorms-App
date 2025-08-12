import 'package:http/http.dart' as http;

import 'package:bookworms_app/models/account/account_details.dart';
import 'package:bookworms_app/resources/network.dart';
import 'package:bookworms_app/utils/http_helpers.dart';

class AccountDetailsEditService {
  final http.Client client;

  AccountDetailsEditService({http.Client? client}) : client = client ?? http.Client();

  // Modifies the first name, last name, or icon index of the account.
  Future<AccountDetails> setAccountDetails(String firstName, String lastName, int iconIndex) async {
    final response = await client.sendRequest(
        uri: userDetailsUri,
        method: "PUT",
        payload: {
          "firstName": firstName,
          "lastName": lastName,
          "icon": iconIndex});

    if (response.ok) {
      return AccountDetails.fromJson(readResponse(response));
    } else {
      throw Exception("An error occurred when editing the user account information.");
    }
  }
}