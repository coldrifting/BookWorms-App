import 'dart:io';

import 'package:http/http.dart' as http;

import 'package:bookworms_app/resources/network.dart';
import 'package:bookworms_app/utils/http_helpers.dart';

/// The [PingService] checks that the server is available
class PingService {
  final http.Client client;

  PingService({http.Client? client}) : client = client ?? http.Client();

  Future<bool> ping() async {
    try {
      final response = await client
          .sendRequest(uri: pingUri(), method: "GET")
          .timeout(const Duration(seconds: 2), onTimeout: () {
        return http.Response('Error Timeout', 408);
      });

      if (response.ok) {
        // Success
        return true;
      }
      return false;
    } catch(_) {
      return false;
    }
  }
}
