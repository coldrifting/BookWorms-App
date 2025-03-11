import 'package:bookworms_app/models/book/bookshelf.dart';
import 'package:bookworms_app/models/classroom/student.dart';
import 'package:bookworms_app/models/goals/classroom_goal.dart';

class Classroom {
  final String classCode;
  final String classroomName;
  final List<Student> students;
  final int classIcon;
  final List<Bookshelf> bookshelves;
  List<ClassroomGoal> classroomGoals = [];

  Classroom({
    required this.classCode,
    required this.classroomName,
    required this.students,
    required this.classIcon,
    required this.bookshelves,
  });

  // Decodes the JSON to create a Classroom object.
  factory Classroom.fromJson(Map<String, dynamic> json) {
    return Classroom(
      classCode: json['classCode'],
      classroomName: json['classroomName'],
      students: json['children'] != null 
      ? (json['children'] as List)
        .map((childJson) => Student.fromJson(childJson))
        .toList()
      : [],
      classIcon: json['classIcon'],
      bookshelves: (json['bookshelves'] as List)
        .map((bookshelfJson) => Bookshelf.fromJson(bookshelfJson))
        .toList(),
    );
  }
}