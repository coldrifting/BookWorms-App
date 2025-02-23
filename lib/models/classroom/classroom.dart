import 'package:bookworms_app/models/book/bookshelf.dart';
import 'package:bookworms_app/models/classroom/student.dart';

class Classroom {
  final String classCode;
  final String classroomName;
  final List<Student> students;
  final List<Bookshelf> bookshelves;
  // TO DO : Create and store a list of ClassroomGoal objects.

  Classroom({
    required this.classCode,
    required this.classroomName,
    required this.students,
    required this.bookshelves,
  });

  // Decodes the JSON to create a Classroom object.
  factory Classroom.fromJson(Map<String, dynamic> json) {
    return Classroom(
      classCode: json['classCode'],
      classroomName: json['classroomName'],
      students: (json['children'] as List)
        .map((childJson) => Student.fromJson(childJson))
        .toList(),
      bookshelves: (json['bookshelves'] as List)
        .map((bookshelfJson) => Bookshelf.fromJson(bookshelfJson))
        .toList(),
    );
  }
}