import 'package:bookworms_app/models/user_review.dart';

/// More detailed book information that shows on the book details screen.
class BookDetails {
  final String description;
  final List<String> subjects;
  final String isbn10;
  final String isbn13;
  final String publisher;
  final String publishDate;
  final int pageCount;
  final List<UserReview> reviews;

  const BookDetails({
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
  factory BookDetails.fromJson(Map<String, dynamic> json) {
    return BookDetails(
      description: json['description'],
      subjects: List<String>.from(json['subjects']),
      isbn10: json['isbn10'],
      isbn13: json['isbn13'],
      publisher: json['publisher'],
      publishDate: json['publishDate'],
      pageCount: json['pageCount'],
      reviews: (json['reviews'] as List)
                .map((reviewJson) => UserReview.fromJson(reviewJson))
                .toList()
    );
  }
}