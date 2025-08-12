import 'package:http/http.dart' as http;

import 'package:bookworms_app/models/book/book_details.dart';
import 'package:bookworms_app/resources/network.dart';
import 'package:bookworms_app/utils/http_helpers.dart';

/// The [BookDetailsService] handles the retrieval of book details from the server.
class BookDetailsService {
  final http.Client client;

  BookDetailsService({http.Client? client}) : client = client ?? http.Client();

  // Retrieve and decode the extended book data of the book id from the server.
  Future<BookDetails> getBookDetails(String bookId) async {
    final response = await client.sendRequest(
        uri: bookDetailsAllUri(bookId),
        method: "GET");

    if (response.ok) {
      return BookDetails.fromJson(readResponse(response));
    }
    else {
      throw Exception('An error occurred when fetching the book details.');
    }
  }
}