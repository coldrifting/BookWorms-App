import 'dart:convert';
import 'package:bookworms_app/models/bookshelf.dart';
import 'package:bookworms_app/services/auth_storage.dart';
import 'package:bookworms_app/services/services_shared.dart';
import 'package:http/http.dart' as http;


class RenameBookshelfService {
  final http.Client client;

  RenameBookshelfService({http.Client? client}) : client = client ?? http.Client();

  Future<List<Bookshelf>> renameBookshelfService(int childId, String oldBookshelfName, String newBookshelfName) async {
    final response = await client.post(
      Uri.parse('http://${ServicesShared.serverAddress}/children/$childId/shelves/$oldBookshelfName/rename?newName=$newBookshelfName}'),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer ${await getToken()}'
      },
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List;
      final bookshelves = data.map((entry) => Bookshelf.fromJson(entry)).toList();
      return bookshelves;
    } else {
      throw Exception('An error occurred when creating a new bookshelf.');
    }
  }
}