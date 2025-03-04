/// Simple book summary information and book image.
class BookSummary {
  final String id;
  final String title;
  final List<String> authors;
  final int? level;
  double? rating;
  String? imageUrl;

  BookSummary({
    required this.id,
    required this.title,
    required this.authors,
    required this.level,
    required this.rating
  });

  // Decodes the JSON to create a BookSummary object.
  factory BookSummary.fromJson(Map<String, dynamic> json) {
    return BookSummary(
      id: json['bookId'],
      title: json['title'],
      authors: List<String>.from(json['authors']),
      level: json['level'],
      rating: json['rating'] != null 
        ? ((json['rating'] as num).toDouble() * 10).roundToDouble() / 10 // Round to 1 decimal place
        : null
    );
  }
}