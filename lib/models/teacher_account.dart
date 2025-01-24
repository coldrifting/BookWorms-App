import 'package:bookworms_app/models/account.dart';
import 'package:bookworms_app/models/book_summary.dart';
import 'package:bookworms_app/models/classroom.dart';

class Teacher extends Account {
  final Classroom classroom;

  Teacher({
    required String username,
    required String firstName,
    required String lastName,
    required int profilePictureIndex,
    required List<BookSummary> recentlySearchedBooks,
    required this.classroom,
  }) : super(
          username: username,
          firstName: firstName,
          lastName: lastName,
          profilePictureIndex: profilePictureIndex,
          recentlySearchedBooks: recentlySearchedBooks,
        );
}