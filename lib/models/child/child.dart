import 'package:bookworms_app/models/book/bookshelf.dart';
import 'package:bookworms_app/models/classroom/classroom.dart';
import 'package:bookworms_app/models/goals/child_goal.dart';

class Child {
  final String id;
  String name;
  int profilePictureIndex;
  int? readingLevel;
  String? dob;
  List<Bookshelf> bookshelves = [];
  List<Classroom> classrooms = [];
  List<ChildGoal> goals = [];

  Child({
    required this.id,
    required this.name, 
    required this.profilePictureIndex,
    this.readingLevel,
    this.dob
  });

  factory Child.fromJson(Map<String, dynamic> json) {
    return Child(
      id: json['childId'],
      name: json['name'],
      profilePictureIndex: json['childIcon'],
      readingLevel: json['readingLevel'],
      dob: json['dateOfBirth']
    );
  }
}