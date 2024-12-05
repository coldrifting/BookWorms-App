import 'dart:convert';
import 'package:bookworms_app/models/user_review.dart';
import 'package:http/http.dart' as http;

class BookReviewsService {
  final http.Client client;

  BookReviewsService({http.Client? client}) : client = client ?? http.Client();

  // Send the user review data to the server.
  Future<UserReview> sendReview(String bookId, String text, double starRating) async {
    final response = await client.put(
      Uri.parse('http://10.0.2.2:5247/books/$bookId/review?username=parent0'),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json'
      },
      body: json.encode({
        "starRating": starRating,
        "reviewText": text
      })
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return UserReview.fromJson(data);
    } else {
      throw Exception('An error occurred when fetching the book image.');
    }
  }
}
