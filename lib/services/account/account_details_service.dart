import 'package:http/http.dart' as http;

import 'package:bookworms_app/models/account/account_details.dart';
import 'package:bookworms_app/models/error/error_basic.dart';
import 'package:bookworms_app/services/status_code_exceptions.dart';
import 'package:bookworms_app/resources/network.dart';
import 'package:bookworms_app/utils/http_helpers.dart';

class AccountDetailsService {
  final http.Client client;

  AccountDetailsService({http.Client? client}) : client = client ?? http.Client();

  Future<AccountDetails> getAccountDetails() async {
    final response =
        await client.sendRequest(uri: userDetailsUri, method: "GET");

    if (response.ok) {
      return AccountDetails.fromJson(readResponse(response));
    } else {
      ErrorBasic error = ErrorBasic.fromJson(readResponse(response));
      throw getStatusCodeException(response.statusCode, error.toString());
    }
  }
}
