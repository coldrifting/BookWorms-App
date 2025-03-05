import 'package:http/http.dart' as http;

import 'package:bookworms_app/resources/network.dart';
import 'package:bookworms_app/utils/http_helpers.dart';

/// The [BookDifficultyService] handles sending the child difficulty data to the server.
class BookDifficultyService {
  final http.Client client;

  BookDifficultyService({http.Client? client}) : client = client ?? http.Client();

  // Send the child difficulty data to the server.
  Future<void> sendDifficulty(String bookId, String childId, int rating) async {
    final response = await client.sendRequest(
      uri: bookDifficultyUri(bookId),
      method: "POST",
      payload: {
        "childId": childId,
        "rating": rating
      }
    );

    if (response.ok) {
      return;
    }
    else {
      throw Exception('An error occurred when sending the review.');
    }
  }
}
