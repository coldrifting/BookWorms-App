import 'package:bookworms_app/models/user_review.dart';

/// More detailed book information, not including the book summary info.
class BookDetails {
  final String description;
  final List<String> subjects;
  final String? isbn10;
  final String? isbn13;
  final int publishYear;
  final int? pageCount;
  final List<UserReview> reviews;

  const BookDetails({
    required this.description,
    required this.subjects,
    // NOTE : At least one of the isbns will be non-empty, but it is not guaranteed both will be non-empty.
    required this.isbn10,
    required this.isbn13,
    required this.publishYear,
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
      publishYear: json['publishYear'],
      pageCount: json['pageCount'],
      reviews: (json['reviews'] as List)
                .map((reviewJson) => UserReview.fromJson(reviewJson))
                .toList()
    );
  }
}