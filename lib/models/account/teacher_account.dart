import 'package:bookworms_app/models/account.dart';
// import 'package:bookworms_app/models/classroom.dart';

class Teacher extends Account {
  // final Classroom classroom;

  Teacher({
    required super.username,
    required super.firstName,
    required super.lastName,
    required super.profilePictureIndex,
    required super.recentlySearchedBooks,
    // required this.classroom,
  });
}