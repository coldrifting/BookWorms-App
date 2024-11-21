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
  Future<List<BookSummary>> getBookSummaries() async {
    final response = await http.get(Uri.parse('http://10.0.2.2:5247/search?query=The'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List<BookSummary> bookSummaries = [];
      for (var i = 0; i < data.length; i++) {
        final entry = data[i];
        bookSummaries.add(BookSummary.fromJson(entry));
      }
      return bookSummaries;
    } else {
      throw Exception('ERROR DETECTED ; WEE WOO WEE WOO ; SOUND THE ALARMS ; THIS IS NOT A DRILL ; THREAT EMINENT ; THE BRITISH ARE COMING');
    }
  }
}
