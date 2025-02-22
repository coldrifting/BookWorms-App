import 'package:http/http.dart' as http;

import 'package:bookworms_app/resources/network.dart';
import 'package:bookworms_app/utils/http_helpers.dart';
import 'package:bookworms_app/models/book/book_summary.dart';

/// The [BookSummaryService] handles the retrieval of book summary (singular) from the server.
class BookSummaryService {
  final http.Client client;

  BookSummaryService({http.Client? client}) : client = client ?? http.Client();

  Future<BookSummary> getBookSummary(String bookId) async {
    final response = await client.sendRequest(
        uri: bookDetailsUri(bookId),
        method: "GET");

    if (response.ok) {
      return BookSummary.fromJson(readResponse(response));
    }
    else {
      throw Exception('An error occurred when fetching the book summary.');
    }
  }
}