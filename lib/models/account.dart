import 'package:bookworms_app/models/book_summary.dart';

class Account {
  final String username;
  final String firstName;
  final String lastName;
  int profilePictureIndex;
  final List<BookSummary> recentlySearchedBooks;

  Account({
    required this.username,
    required this.firstName,
    required this.lastName,
    required this.profilePictureIndex,
    required this.recentlySearchedBooks,
  });

  // Decodes the JSON to create a Account object.
  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
      username: json['username'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      profilePictureIndex: json['profilePictureIndex'],
      recentlySearchedBooks: [],
    );
  }
}