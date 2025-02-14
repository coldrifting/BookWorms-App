import 'dart:convert';
import 'package:bookworms_app/models/book_summary.dart';
import 'package:bookworms_app/services/services_shared.dart';
import 'package:http/http.dart' as http;


class BookSummaryService {
  final http.Client client;

  BookSummaryService({http.Client? client}) : client = client ?? http.Client();

  Future<BookSummary> getBookSummary(String bookId) async {
    final response = await client.get(Uri.parse('${ServicesShared.serverAddress}/books/$bookId/details'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return BookSummary.fromJson(data);
    } else {
      throw Exception('An error occurred when fetching the book summary.');
    }
  }
}