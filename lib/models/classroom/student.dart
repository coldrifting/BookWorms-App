class Student {
  final String id;
  final String name;
  int profilePictureIndex;
  int? readingLevel;
  String? dateOfBirth;

  Student({
    required this.id,
    required this.name,
    required this.profilePictureIndex,
    required this.readingLevel,
    required this.dateOfBirth
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['childId'],
      name: json['name'],
      profilePictureIndex: json['childIcon'],
      readingLevel: json['readingLevel'],
      dateOfBirth: json['dateOfBirth']
    );
  }
}