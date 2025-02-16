import 'package:http/http.dart' as http;

import 'package:bookworms_app/resources/network.dart';
import 'package:bookworms_app/utils/http_helpers.dart';
import 'package:bookworms_app/models/book_summary.dart';

/// The [BookSummariesService] handles the retrieval of book summaries from the server.
class BookSummariesService {
  final http.Client client;

  BookSummariesService({http.Client? client}) : client = client ?? http.Client();

  // Retrieve and decode the book summaries of the given query from the server.
  Future<List<BookSummary>> getBookSummaries(String query, int resultLength) async {
    final response = await client.sendRequest(
        uri: searchQueryUri(query),
        method: "GET");

    if (response.ok) {
      return fromResponseListBookSummary(response);
    }
    else {
      throw Exception('An error occurred when fetching book summaries.');
    }
  }
}