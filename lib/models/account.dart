import 'package:bookworms_app/models/book_summary.dart';
import 'package:hive/hive.dart';

part 'account.g.dart';

@HiveType(typeId: 0)
class Account {
  @HiveField(0)
  final String username;
  @HiveField(1)
  final String firstName;
  @HiveField(2)
  final String lastName;
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