import 'dart:convert';
import 'package:http/http.dart' as http;

/// Basic book information that shows on the search screen.
class BookSummary {
  final String id;
  final String image;
  final String title;
  final List<String> authors;
  final String? difficulty;
  final double? rating;

  const BookSummary({
    required this.id,
    required this.image,
    required this.title,
    required this.authors,
    required this.difficulty,
    required this.rating
  });

  // Decodes the JSON to create a BookSummary object.
  factory BookSummary.fromJson(Map<String, dynamic> json) {
    return BookSummary(
      id: json['bookId'],
      image: json['image'],
      title: json['title'],
      authors: List<String>.from(json['authors']),
      difficulty: json['difficulty'],
      rating: (json['rating'] as num).toDouble()
    );
  }
}

/// More detailed book information that shows on the book details screen.
class BookExtended {
  final String image;
  final String title;
  final List<String> authors;
  final String? difficulty;
  final double? rating;
  final String description;
  final List<String> subjects;
  final String isbn10;
  final String isbn13;
  final String publisher;
  final String publishDate;
  final int pageCount;
  final List<Review> reviews;

  const BookExtended({
    required this.image,
    required this.title,
    required this.authors,
    required this.difficulty,
    required this.rating,
    required this.description,
    required this.subjects,
    required this.isbn10,
    required this.isbn13,
    required this.publisher,
    required this.publishDate,
    required this.pageCount,
    required this.reviews
  });

  // Decodes the JSON to create a BookExtended object.
  factory BookExtended.fromJson(Map<String, dynamic> json) {
    return BookExtended(
      image: json['image'],
      title: json['title'],
      authors: List<String>.from(json['authors']),
      difficulty: json['difficulty'],
      rating: (json['rating'] as num).toDouble(),
      description: json['description'],
      subjects: List<String>.from(json['subjects']),
      isbn10: json['isbn10'],
      isbn13: json['isbn13'],
      publisher: json['publisher'],
      publishDate: json['publishDate'],
      pageCount: json['pageCount'],
      reviews: (json['reviews'] as List)
                .map((reviewJson) => Review.fromJson(reviewJson))
                .toList()
    );
  }

}

/// Represents a user review.
class Review {
  final String reviewerUsername;
  final String reviewerName;
  final double starRating; 
  final String reviewText;

  const Review({
    required this.reviewerUsername,
    required this.reviewerName,
    required this.starRating,
    required this.reviewText
  });

  // Decodes the JSON to create a Review object.
  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      reviewerUsername: json['reviewerUsername'],
      reviewerName: json['reviewerName'],
      starRating: (json['starRating'] as num).toDouble(),
      reviewText: json['reviewText']
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
      throw Exception('An error occured when fetching search results.');
    }
  }

  Future<BookExtended> getBookExtended(String bookId) async {
    final response = await http.get(Uri.parse('http://10.0.2.2:5247/books/$bookId/details'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return BookExtended.fromJson(data);
    } else {
      throw Exception('An error occurred when fetching book details.');
    }
  }
}