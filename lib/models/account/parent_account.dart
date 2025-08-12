import 'package:bookworms_app/models/account/account.dart';
import 'package:bookworms_app/models/child/child.dart';

class Parent extends Account {
  List<Child> children;
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