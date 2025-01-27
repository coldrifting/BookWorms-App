import 'package:hive/hive.dart';

@HiveType(typeId: 6)
class Student {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  int profilePictureIndex;

  Student({
    required this.id,
    required this.name,
    required this.profilePictureIndex,
  });
}