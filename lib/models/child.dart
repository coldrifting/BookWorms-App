class Child {
  final String id;
  String name;
  int profilePictureIndex;

  Child({
    required this.id,
    required this.name, 
    required this.profilePictureIndex
  });

  factory Child.fromJson(Map<String, dynamic> json) {
    return Child(
      id: json['childId'],
      name: json['name'],
      profilePictureIndex: json['childIcon']
    );
  }
}