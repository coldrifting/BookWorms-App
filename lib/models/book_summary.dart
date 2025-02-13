/// Simple book summary information and book image.
class BookSummary {
  final String id;
  final String title;
  final List<String> authors;
  final String difficulty;
  final double? rating;
  String? imageUrl;

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
      // difficulty: json['difficulty'],
      difficulty: 'N/A',
      rating: json['rating'] != null ? (json['rating'] as num).toDouble() : null
    );
  }

  void setImage(String newImageUrl) {
    imageUrl = newImageUrl;
  }
}