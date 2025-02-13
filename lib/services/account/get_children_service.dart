import 'package:bookworms_app/models/child.dart';
import 'package:bookworms_app/resources/network.dart';
import 'package:bookworms_app/utils/http_client_ext.dart';
import 'package:bookworms_app/utils/http_helpers.dart';

class GetChildrenService {
  final HttpClientExt client;

  GetChildrenService({HttpClientExt? client}) : client = client ?? HttpClientExt();

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