import 'package:flutter/material.dart';

/// Simple book information that shows on the search screen, as well as the
/// book details screen.
class BookSummary {
  final String id;
  final String title;
  final List<String> authors;
  final String difficulty;
  final double rating;
  Image? image;

  BookSummary({
    required this.id,
    required this.title,
    required this.authors,
    required this.difficulty,
    required this.rating
  });

  // Decodes the JSON to create a BookSummary object.
  factory BookSummary.fromJson(Map<String, dynamic> json) {
    return BookSummary(
      id: json['bookId'],
      title: json['title'],
      authors: List<String>.from(json['authors']),
      difficulty: json['difficulty'],
      rating: (json['rating'] as num).toDouble()
    );
  }

  void setImage(Image newImage) {
    image = newImage;
  }
}