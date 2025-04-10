import 'dart:convert';
import 'package:bookworms_app/models/book/book_summary.dart';
import 'package:bookworms_app/models/book/bookshelf.dart';
import 'package:bookworms_app/resources/network.dart';
import 'package:bookworms_app/utils/http_helpers.dart';
import 'package:http/http.dart' as http;

class BookshelfService {
  final http.Client client;

  BookshelfService({http.Client? client}) : client = client ?? http.Client();

  Future<void> addBookshelf(String guid, String bookshelfName) async {
    final response = await client.sendRequest(
        uri: bookshelvesAddUri(guid, bookshelfName),
        method: "POST");

    if (!response.ok) {
      throw Exception('An error occurred when creating a new bookshelf.');
    }
  }

  Future<void> deleteBookshelf(String guid, String bookshelfName) async {
    final response = await client.sendRequest(
        uri: bookshelvesDeleteUri(guid, bookshelfName),
        method: "DELETE");

    if (!response.ok) {
      throw Exception('An error occurred when trying to delete the bookshelf.');
    }
  }

  Future<Bookshelf> getBookshelf(String guid, Bookshelf bookshelf) async {
    final response = await client.sendRequest(
        uri: bookshelvesDetailsUri(guid, bookshelf.type.name, bookshelf.name),
        method: "GET");

    if (response.ok) {
      final data = jsonDecode(response.body);
      return Bookshelf.fromJson(data);
    } else {
      throw Exception("An error occurred when fetching the child's bookshelf.");
    }
  }

  Future<List<BookSummary>> getRecommendedAuthorsBookshelf([String? guid]) async {
    final response = await client.sendRequest(
        uri: bookshelvesRecommendAuthorsUri(guid),
        method: "GET");

    if (response.ok) {
      final data = jsonDecode(response.body) as List;
      return data.map((entry) => BookSummary.fromJson(entry)).toList();
    } else {
      throw Exception("An error occurred when fetching the child's recommended bookshelf.");
    }
  }

  Future<List<BookSummary>> getRecommendedDescriptionBookshelf(String? guid) async {
    final response = await client.sendRequest(
        uri: bookshelvesRecommendDescriptionsUri(guid),
        method: "GET");

    if (response.ok) {
      final data = jsonDecode(response.body) as List;
      return data.map((entry) => BookSummary.fromJson(entry)).toList();
    } else {
      throw Exception("An error occurred when fetching the child's recommended bookshelf.");
    }
  }

  Future<List<BookSummary>> getPositivelyReviewedBookshelf([String? guid]) async {
    final response = await client.sendRequest(
        uri: bookshelvesPositivelyReviewedUri(guid),
        method: "GET");

    if (response.ok) {
      final data = jsonDecode(response.body) as List;
      return data.map((entry) => BookSummary.fromJson(entry)).toList();
    } else {
      throw Exception("An error occurred when fetching the child's recommended bookshelf.");
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

  Future<void> renameBookshelfService(String guid, String oldBookshelfName, String newBookshelfName) async {
    final response = await client.sendRequest(
        uri: bookshelvesRenameUri(guid, oldBookshelfName, newBookshelfName),
        method: "POST");

    if (!response.ok) {
      throw Exception('An error occurred when creating a new bookshelf.');
    }
  }

  Future<void> removeBookFromBookshelf(String guid, String bookshelfName, String bookId) async {
    final response = await client.sendRequest(
        uri: bookshelvesRemoveUri(guid, bookshelfName, bookId),
        method: "DELETE");

    if (!response.ok) {
      throw Exception('An error occurred when trying to remove a book from the bookshelf.');
    }
  }

  Future<Bookshelf> addBookToBookshelf(String guid, String bookshelfName, String bookId) async {
    final response = await client.sendRequest(
        uri: bookshelvesInsertUri(guid, bookshelfName, bookId),
        method: "PUT");

    if (response.ok) {
      final data = jsonDecode(response.body);
      return Bookshelf.fromJson(data);
    } else {
      throw Exception('An error occurred when trying to add a book to the bookshelf.');
    }
  }
}