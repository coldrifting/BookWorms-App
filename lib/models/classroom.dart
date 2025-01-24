import 'package:bookworms_app/models/book_summary.dart';
import 'package:bookworms_app/models/student.dart';

class Classroom {
  final String classroomName;
  final String teacherName;
  final List<Student> students;
  final List<BookSummary> bookshelf;
  // TO DO : Create and store a list of ClassroomGoal objects.

  Classroom({
    required this.classroomName,
    required this.teacherName,
    required this.students,
    required this.bookshelf,
  });
}