import 'package:bookworms_app/models/action_result.dart';
import 'package:http/http.dart' as http;

import 'package:bookworms_app/resources/network.dart';
import 'package:bookworms_app/utils/http_helpers.dart';

/// The [BookDifficultyService] handles sending the child difficulty data to the server.
class BookDifficultyService {
  final http.Client client;

  BookDifficultyService({http.Client? client}) : client = client ?? http.Client();

  // Send the child difficulty data to the server.
  Future<Result> sendDifficulty(String bookId, String childId, int rating) async {
    final response = await client.sendRequest(
      uri: bookDifficultyUri(bookId),
      method: "POST",
      payload: {
        "childId": childId,
        "rating": rating
      }
    );

    if (response.ok) {
      if (response.body.isEmpty) {
        return Result(isSuccess: false, message: "Set your child's birthday first to rate this book.");
      }
      else {
        return Result(isSuccess: true, message: "This book's difficulty has been successfully rated.");
      }
    }
    else {
      return Result(isSuccess: false, message: "The selected child has already rated this book.");
    }
  }
}
