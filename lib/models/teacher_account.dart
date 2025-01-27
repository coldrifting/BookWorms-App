import 'package:bookworms_app/models/account.dart';
// import 'package:bookworms_app/models/classroom.dart';
import 'package:hive/hive.dart';

@HiveType(typeId: 2)
class Teacher extends Account {
  @HiveField(5)
  // final Classroom classroom;

  Teacher({
    required super.username,
    required super.firstName,
    required super.lastName,
    required super.profilePicture,
    required super.recentlySearchedBooks,
    // required this.classroom,
  });
}