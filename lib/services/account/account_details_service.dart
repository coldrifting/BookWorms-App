import 'package:bookworms_app/utils/http_client_ext.dart';
import 'package:bookworms_app/models/account_details.dart';
import 'package:bookworms_app/models/error_basic.dart';
import 'package:bookworms_app/services/status_code_exceptions.dart';
import 'package:bookworms_app/resources/network.dart';
import 'package:bookworms_app/utils/http_helpers.dart';

class AccountDetailsService {
  final HttpClientExt client;

  AccountDetailsService({HttpClientExt? client}) : client = client ?? HttpClientExt();

  Future<AccountDetails> getAccountDetails() async {
    final response =
        await client.sendRequest(uri: userDetailsUri, method: "GET");

    if (response.ok) {
      return AccountDetails.fromJson(await readResponse(response));
    } else {
      ErrorBasic error = ErrorBasic.fromJson(await readResponse(response));
      throw getStatusCodeException(response.statusCode, error.toString());
    }
  }
}
