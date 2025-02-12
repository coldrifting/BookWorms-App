import 'dart:convert';
import 'package:bookworms_app/models/bookshelf.dart';
import 'package:bookworms_app/services/auth_storage.dart';
import 'package:bookworms_app/services/services_shared.dart';
import 'package:http/http.dart' as http;


class GetBookshelfService {
  final http.Client client;

  GetBookshelfService({http.Client? client}) : client = client ?? http.Client();

  Future<Bookshelf> getBookshelf(int childId, String bookshelfName) async {
    final response = await client.get(
      Uri.parse('http://${ServicesShared.serverAddress}/children/$childId/shelves/$bookshelfName/details}'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer ${await getToken()}'
      },
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return Bookshelf.fromJson(data);
    } else {
      throw Exception("An error occurred when fetching the child's bookshelves.");
    }
  }
}