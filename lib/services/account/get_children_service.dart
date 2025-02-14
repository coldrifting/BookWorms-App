import 'dart:convert';
import 'package:bookworms_app/models/child.dart';
import 'package:bookworms_app/services/auth_storage.dart';
import 'package:bookworms_app/services/services_shared.dart';
import 'package:http/http.dart' as http;

class GetChildrenService {
  final http.Client client;

  GetChildrenService({http.Client? client}) : client = client ?? http.Client();

  Future<List<Child>> getChildren() async {
    final response = await client.get(
      Uri.parse('${ServicesShared.serverAddress}/children/all'),
      headers: {
        'accept': 'application/json',
        'Authorization': 'Bearer ${await getToken()}'
      },
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List<Child> children = [];
      for (var i = 0; i < data.length; i++) {
        final entry = data[i];
        children.add(Child.fromJson(entry));
      }
      return children;
    } else {
      throw Exception('An error occured when fetching children.');
    }
  }
}