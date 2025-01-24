import 'package:bookworms_app/models/account.dart';
import 'package:bookworms_app/models/book_summary.dart';
import 'package:bookworms_app/models/child.dart';

class Parent extends Account {
  final List<Child> children;

  Parent({
    required String username,
    required String firstName,
    required String lastName,
    required int profilePictureIndex,
    required List<BookSummary> recentlySearchedBooks,
    required this.children,
  }) : super(
          username: username,
          firstName: firstName,
          lastName: lastName,
          profilePictureIndex: profilePictureIndex,
          recentlySearchedBooks: recentlySearchedBooks,
        );
}