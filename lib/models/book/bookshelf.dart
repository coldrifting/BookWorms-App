import 'package:bookworms_app/models/book/book_summary.dart';

class Bookshelf {
  String name;
  List<BookSummary> books;

  Bookshelf({
    required this.name, 
    required this.books
  });

  factory Bookshelf.fromJson(Map<String, dynamic> json) {
    return Bookshelf(
      name: json['name'],
      books: (json['books'] as List)
                .map((reviewJson) => BookSummary.fromJson(reviewJson))
                .toList()
    );
  }
}