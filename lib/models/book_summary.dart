import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

/// Simple book summary information and book image.
@HiveType(typeId: 3)
class BookSummary {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String title;
  @HiveField(2)
  final List<String> authors;
  @HiveField(3)
  final String difficulty;
  @HiveField(4)
  final double rating;
  Image? image;
  @HiveField(5)
  String? imagePath;

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