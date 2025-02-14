import 'dart:convert';
import 'package:bookworms_app/models/bookshelf.dart';
import 'package:bookworms_app/services/auth_storage.dart';
import 'package:bookworms_app/services/services_shared.dart';
import 'package:http/http.dart' as http;

class BookshelfService {
  final http.Client client;

  BookshelfService({http.Client? client}) : client = client ?? http.Client();

  Future<List<Bookshelf>> addBookshelf(String guid, String bookshelfName) async {
    final response = await client.post(
      Uri.parse('${ServicesShared.serverAddress}/children/$guid/shelves/$bookshelfName/add'),
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

  Future<List<Bookshelf>> deleteBookshelf(String guid, String bookshelfName) async {
    final response = await client.delete(
      Uri.parse('${ServicesShared.serverAddress}/children/$guid/shelves/$bookshelfName/delete'),
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
      throw Exception('An error occurred when trying to delete the bookshelf.');
    }
  }

  Future<Bookshelf> getBookshelf(String guid, String bookshelfName) async {
    final response = await client.get(
      Uri.parse('${ServicesShared.serverAddress}/children/$guid/shelves/$bookshelfName/details'),
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

  Future<List<Bookshelf>> getBookshelves(String guid) async {
    final response = await client.get(
      Uri.parse('${ServicesShared.serverAddress}/children/$guid/shelves'),
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
      throw Exception("An error occurred when fetching the child's bookshelves.");
    }
  }

  Future<List<Bookshelf>> renameBookshelfService(String guid, String oldBookshelfName, String newBookshelfName) async {
    final response = await client.post(
      Uri.parse('${ServicesShared.serverAddress}/children/$guid/shelves/$oldBookshelfName/rename?newName=$newBookshelfName'),
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