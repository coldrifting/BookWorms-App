import 'dart:collection';

import 'package:bookworms_app/models/book_summary.dart';

class Account {
  String username;
  String firstName;
  String lastName;
  int profilePictureIndex;
  final ListQueue<BookSummary> recentlySearchedBooks;

  Account({
    required this.username,
    required this.firstName,
    required this.lastName,
    required this.profilePictureIndex,
    required this.recentlySearchedBooks,
  });
}