import 'package:hive/hive.dart';

@HiveType(typeId: 0)
class Account {
  @HiveField(0)
  String username;
  @HiveField(1)
  String firstName;
  @HiveField(2)
  String lastName;
  @HiveField(3)
  int profilePictureIndex;
  @HiveField(4)
  final List<String> recentlySearchedBooks;

  Account({
    required this.username,
    required this.firstName,
    required this.lastName,
    required this.profilePictureIndex,
    required this.recentlySearchedBooks,
  });
}