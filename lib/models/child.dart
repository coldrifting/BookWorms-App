import 'package:hive/hive.dart';

@HiveType(typeId: 4)
class Child {
  //final String id;
  @HiveField(0)
  String name;
  int iconIndex;

  Child({
    required this.name, 
    required this.iconIndex
  });
}