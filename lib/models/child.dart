import 'package:hive/hive.dart';

part 'child.g.dart';

@HiveType(typeId: 4)
class Child {
  //final String id;
  @HiveField(0)
  String name;
  //final String readingLevel;
  //int profilePictureIndex;
  // TO DO : Create and store a list of ReadingGoal objects.
  // TO DO : Create and store a Bookshelf object.
  // TO DO : Create and store a EnrolledClassroom object.

  Child({
    //required this.id,
    required this.name,
    //required this.readingLevel,
    //required this.profilePictureIndex,
  });
}