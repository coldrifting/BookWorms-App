import 'package:bookworms_app/models/account.dart';
import 'package:bookworms_app/models/child.dart';
import 'package:hive/hive.dart';
import 'package:bookworms_app/models/book_summary.dart';

part 'parent_account.g.dart';

@HiveType(typeId: 1)
class Parent extends Account {
  @HiveField(5)
  final List<Child> children;

  Parent({
    required super.username,
    required super.firstName,
    required super.lastName,
    required super.profilePictureIndex,
    required super.recentlySearchedBooks,
    required this.children,
  });
}