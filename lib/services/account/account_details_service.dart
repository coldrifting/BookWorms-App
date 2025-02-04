import 'dart:convert';
import 'package:bookworms_app/models/account_details.dart';
import 'package:bookworms_app/services/auth_storage.dart';
import 'package:bookworms_app/services/services_shared.dart';
import 'package:bookworms_app/services/status_code_exceptions.dart';
import 'package:http/http.dart' as http;

class AccountDetailsService {
  final http.Client client;

  AccountDetailsService({http.Client? client}) : client = client ?? http.Client();

  Future<AccountDetails> getAccountDetails() async {
    final response = await client.get(
      Uri.parse('http://${ServicesShared.serverAddress}/user/details'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer ${await getToken()}'
      },
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return AccountDetails.fromJson(data);
    } else {
       throw getStatusCodeException(response.statusCode, response.body);
    }
  }
}