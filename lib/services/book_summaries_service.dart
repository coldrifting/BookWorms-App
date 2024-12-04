import 'dart:convert';
import 'package:bookworms_app/models/book_summary.dart';
import 'package:http/http.dart' as http;

/// The [BookDetailsService] handles the retrieval of book summaries from the server.
class BookSummariesService {
  final http.Client client;

  BookSummariesService({http.Client? client}) : client = client ?? http.Client();

  // Retrieve the book summaries of the given query from the server.
  Future<List<BookSummary>> getBookSummaries(String query, int resultLength) async {
    final response = await client.get(Uri.parse('http://10.0.2.2:5247/search/title?query=$query'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List<BookSummary> bookSummaries = [];
      for (var i = 0; i < data.length; i++) {
        final entry = data[i];
        bookSummaries.add(BookSummary.fromJson(entry));
      }
      return bookSummaries;
    } else {
      throw Exception('An error occured when fetching book summaries.');
    }
  }
}