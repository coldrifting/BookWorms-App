import 'dart:convert';
import 'package:bookworms_app/models/bookshelf.dart';
import 'package:bookworms_app/resources/network.dart';
import 'package:bookworms_app/utils/http_helpers.dart';
import 'package:http/http.dart' as http;

class BookshelfService {
  final http.Client client;

  BookshelfService({http.Client? client}) : client = client ?? http.Client();

  Future<List<Bookshelf>> addBookshelf(String guid, String bookshelfName) async {
    final response = await client.sendRequest(
        uri: bookshelvesAddUri(guid, bookshelfName),
        method: "POST");

    if (response.ok) {
      final data = jsonDecode(response.body) as List;
      final bookshelves = data.map((entry) => Bookshelf.fromJson(entry)).toList();
      return bookshelves;
    } else {
      throw Exception('An error occurred when creating a new bookshelf.');
    }
  }

  Future<List<Bookshelf>> deleteBookshelf(String guid, String bookshelfName) async {
    final response = await client.sendRequest(
        uri: bookshelvesDeleteUri(guid, bookshelfName),
        method: "DELETE");

    if (response.ok) {
      final data = jsonDecode(response.body) as List;
      final bookshelves = data.map((entry) => Bookshelf.fromJson(entry)).toList();
      return bookshelves;
    } else {
      throw Exception('An error occurred when trying to delete the bookshelf.');
    }
  }

  Future<Bookshelf> getBookshelf(String guid, String bookshelfName) async {
    final response = await client.sendRequest(
        uri: bookshelvesDetailsUri(guid, bookshelfName),
        method: "GET");

    if (response.ok) {
      final data = jsonDecode(response.body);
      return Bookshelf.fromJson(data);
    } else {
      throw Exception("An error occurred when fetching the child's bookshelves.");
    }
  }

  Future<List<Bookshelf>> getBookshelves(String guid) async {
    final response = await client.sendRequest(
        uri: bookshelvesUri(guid),
        method: "GET");

    if (response.ok) {
      final data = jsonDecode(response.body) as List;
      final bookshelves = data.map((entry) => Bookshelf.fromJson(entry)).toList();
      return bookshelves;
    } else {
      throw Exception("An error occurred when fetching the child's bookshelves.");
    }
  }

  Future<List<Bookshelf>> renameBookshelfService(String guid, String oldBookshelfName, String newBookshelfName) async {
    final response = await client.sendRequest(
        uri: bookshelvesRenameUri(guid, oldBookshelfName, newBookshelfName),
        method: "POST");

    if (response.ok) {
      final data = jsonDecode(response.body) as List;
      final bookshelves = data.map((entry) => Bookshelf.fromJson(entry)).toList();
      return bookshelves;
    } else {
      throw Exception('An error occurred when creating a new bookshelf.');
    }
  }
}