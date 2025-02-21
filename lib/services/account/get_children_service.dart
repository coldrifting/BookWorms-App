import 'package:http/http.dart' as http;

import 'package:bookworms_app/models/child/child.dart';
import 'package:bookworms_app/resources/network.dart';
import 'package:bookworms_app/utils/http_helpers.dart';

class GetChildrenService {
  final http.Client client;

  GetChildrenService({http.Client? client}) : client = client ?? http.Client();

  Future<List<Child>> getChildren() async {
    final response = await client.sendRequest(
        uri: childrenAllUri,
        method: "GET");

    if (response.ok) {
      return await fromResponseListChild(response);
    }
    else {
      throw Exception('An error occurred when fetching children.');
    }
  }
}