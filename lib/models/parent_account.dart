import 'package:bookworms_app/models/account.dart';
import 'package:bookworms_app/models/child.dart';
import 'package:hive/hive.dart';

@HiveType(typeId: 1)
class Parent extends Account {
  @HiveField(5)
  final List<Child> children;
  @HiveField(6)
  int selectedChildID;

  Parent({
    required super.username,
    required super.firstName,
    required super.lastName,
    required super.profilePictureIndex,
    required super.recentlySearchedBooks,
    required this.children,
    required this.selectedChildID,
  });
}