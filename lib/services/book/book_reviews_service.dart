import 'package:http/http.dart' as http;

import 'package:bookworms_app/resources/network.dart';
import 'package:bookworms_app/utils/http_helpers.dart';
import 'package:bookworms_app/models/user_review.dart';

/// The [BookReviewsService] handles the retrieval of book reviews from the server.
class BookReviewsService {
  final http.Client client;

  BookReviewsService({http.Client? client}) : client = client ?? http.Client();

  // Send the user review data to the server.
  Future<UserReview> sendReview(String bookId, String text, double starRating) async {
    final response = await client.sendRequest(
        uri: bookReviewUri(bookId),
        method: "PUT",
        payload: {
          "starRating": starRating,
          "reviewText": text});

    if (response.ok) {
      return UserReview.fromJson(readResponse(response));
    }
    else {
      throw Exception('An error occurred when sending the review.');
    }
  }
}
