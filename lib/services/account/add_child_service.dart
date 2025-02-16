import 'package:http/http.dart' as http;

import 'package:bookworms_app/models/child.dart';
import 'package:bookworms_app/resources/network.dart';
import 'package:bookworms_app/utils/http_helpers.dart';

class AddChildService {
  final http.Client client;

  AddChildService({http.Client? client}) : client = client ?? http.Client();

  Future<Child> addChild(String childName) async {
    final response = await client.sendRequest(
        uri: childAddUri(childName),
        method: "POST");

    if (response.ok) {
      final List<Child> children = await fromResponseListChild(response);

      final String childId = getChildId(response);
      return children.singleWhere((val) => val.id == childId);
    }
    else {
      throw Exception('An error occurred when adding a child.');
    }
  }
}