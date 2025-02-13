import 'package:bookworms_app/resources/network.dart';
import 'package:bookworms_app/utils/http_client_ext.dart';
import 'package:bookworms_app/utils/http_helpers.dart';
import 'package:bookworms_app/models/book_summary.dart';

/// The [BookSummaryService] handles the retrieval of book summary (singular) from the server.
class BookSummaryService {
  final HttpClientExt client;

  BookSummaryService({HttpClientExt? client}) : client = client ?? HttpClientExt();

  Future<BookSummary> getBookSummary(String bookId) async {
    final response = await client.sendRequest(
        uri: bookDetailsUri(bookId),
        method: "GET");

    if (response.ok) {
      return BookSummary.fromJson(await readResponse(response));
    }
    else {
      throw Exception('An error occurred when fetching the book summary.');
    }
  }
}