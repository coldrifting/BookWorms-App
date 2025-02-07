import 'dart:convert';
import 'package:bookworms_app/models/book_details.dart';
import 'package:bookworms_app/services/services_shared.dart';
import 'package:http/http.dart' as http;

/// The [BookDetailsService] handles the retrieval of book details from the server.
class BookDetailsService {
  final http.Client client;

  BookDetailsService({http.Client? client}) : client = client ?? http.Client();

  // Retrieve and decode the extended book data of the book id from the server.
  Future<BookDetails> getBookDetails(String bookId) async {
    final response = await client.get(Uri.parse('http://${ServicesShared.serverAddress}/books/$bookId/details/all'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return BookDetails.fromJson(data);
    } else {
      throw Exception('An error occurred when fetching the book details.');
    }
  }
}