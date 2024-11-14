import 'dart:convert';
import 'package:http/http.dart' as http;

class BookSummary {
  final String cover;
  final String title;
  final String author;
  final String? difficulty;
  final double? rating;

  const BookSummary({
    required this.cover,
    required this.title,
    required this.author,
    required this.difficulty,
    required this.rating
  });

  factory BookSummary.fromJson(Map<String, dynamic> json) {
    return BookSummary(
      cover: json['cover'],
      title: json['title'],
      author: json['author'],
      difficulty: json['difficulty'],
      rating: json['rating']
    );
  }
}

class SearchService {
  Future<List<BookSummary>> getBookSummaries() async {
    final response = await http.get(Uri.parse("https://youtube.com"));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List<BookSummary> bookSummaries = [];
      for (var i = 0; i < data['results'].length; i++) {
        final entry = data['results'][i];
        bookSummaries.add(BookSummary.fromJson(entry));
      }
      return bookSummaries;
    } else {
      throw Exception('ERROR DETECTED ; WEE WOO WEE WOO ; SOUND THE ALARMS ; THIS IS NOT A DRILL ; THREAT EMINENT ; THE BRITISH ARE COMING');
    }
  }
}