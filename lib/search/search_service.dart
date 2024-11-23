import 'dart:convert';
import 'package:http/http.dart' as http;

class BookSummary {
  final String image;
  final String title;
  final List<String> authors;
  final String? difficulty;
  final double? rating;

  const BookSummary({
    required this.image,
    required this.title,
    required this.authors,
    required this.difficulty,
    required this.rating
  });

  // Decodes the JSON to create a BookSummary object.
  factory BookSummary.fromJson(Map<String, dynamic> json) {
    return BookSummary(
      image: json['image'],
      title: json['title'],
      authors: List<String>.from(json['authors']),
      difficulty: json['difficulty'],
      rating: (json['rating'] as num).toDouble()
    );
  }
}

class SearchService {
  // Retrieves the book summaries of the given query from the back-end server.
  Future<List<BookSummary>> getBookSummaries(String query, int resultLength) async {
    final response = await http.get(Uri.parse('http://10.0.2.2:5247/search/title?query=$query'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List<BookSummary> bookSummaries = [];
      for (var i = 0; i < data.length; i++) {
        final entry = data[i];
        bookSummaries.add(BookSummary.fromJson(entry));
      }
      return bookSummaries;
    } else {
      throw Exception('An error occured when fetching search results');
    }
  }
}