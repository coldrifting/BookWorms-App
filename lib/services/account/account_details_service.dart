import 'dart:convert';
import 'package:bookworms_app/models/account_details.dart';
import 'package:bookworms_app/services/auth_storage.dart';
import 'package:bookworms_app/services/services_shared.dart';
import 'package:http/http.dart' as http;

class AccountDetailsService {
  final http.Client client;

  AccountDetailsService({http.Client? client}) : client = client ?? http.Client();

  Future<AccountDetails> getAccountDetails() async {
    final response = await client.get(
      Uri.parse('http://${ServicesShared.serverAddress}/user/details'),
      headers: {
        'accept': 'application/json',
        'Authorization': 'Bearer ${await getToken()}'
      },
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return AccountDetails.fromJson(data);
    } else {
      throw Exception('An error occurred when fetching the book details.');
    }
  }
}