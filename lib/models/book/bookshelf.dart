import 'package:bookworms_app/models/book/book_summary.dart';
import 'package:bookworms_app/resources/constants.dart';

class Bookshelf {
  BookshelfType type;
  String name;
  List<BookSummary> books;
  List<Completion>? completedDates; // Non-null for "Completed" bookshelf

  Bookshelf({
    required this.type,
    required this.name,
    required this.books,
    this.completedDates
  });

  factory Bookshelf.fromJson(Map<String, dynamic> json) {
    return Bookshelf(
      type: switch(json['type']) {
        'Completed' => BookshelfType.completed,
        'InProgress' => BookshelfType.inProgress,
        'Custom' => BookshelfType.custom,
        'Classroom' => BookshelfType.classroom,
        _ => throw ArgumentError("Invalid bookshelf type: ${json['type']}")
      },
      name: json['name'],
      books: (json['books'] as List)
        .map((reviewJson) => BookSummary.fromJson(reviewJson))
        .toList(),
      completedDates: json['completions'] != null
        ? (json['completions'] as List)
          .map((dateJson) => Completion.fromJson(dateJson))
          .toList()
        : null
    );
  }
}

class Completion {
  String bookId;
  String completedDate;

  Completion({
    required this.bookId,
    required this.completedDate
  });

  factory Completion.fromJson(Map<String, dynamic> json) {
    return Completion(
      bookId: json['bookId'],
      completedDate: json['completedDate']
    );
  }
}