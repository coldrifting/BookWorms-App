import 'package:hive/hive.dart';

@HiveType(typeId: 0)
class Account {
  @HiveField(0)
  final String username;
  @HiveField(1)
  final String firstName;
  @HiveField(2)
  final String lastName;
  @HiveField(3)
  String profilePicture;
  @HiveField(4)
  final List<String> recentlySearchedBooks;

  Account({
    required this.username,
    required this.firstName,
    required this.lastName,
    required this.profilePicture,
    required this.recentlySearchedBooks,
  });
}