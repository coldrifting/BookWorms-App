import 'package:bookworms_app/models/book_summary.dart';
import 'package:bookworms_app/models/student.dart';
import 'package:hive/hive.dart';

part 'classroom.g.dart';

@HiveType(typeId: 5)
class Classroom {
  @HiveField(0)
  final String classroomName;
  @HiveField(1)
  final String teacherName;
  @HiveField(2)
  final List<Student> students;
  @HiveField(3)
  final List<String> bookshelf;
  // TO DO : Create and store a list of ClassroomGoal objects.

  Classroom({
    required this.classroomName,
    required this.teacherName,
    required this.students,
    required this.bookshelf,
  });
}