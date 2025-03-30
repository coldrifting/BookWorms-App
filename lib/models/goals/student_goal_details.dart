class StudentGoalDetails {
  final String name;
  final int icon;
  final int progress;

  StudentGoalDetails({
    required this.name,
    required this.icon,
    required this.progress
  });

  factory StudentGoalDetails.fromJson(Map<String, dynamic> json) {
    return StudentGoalDetails(
      name: json['name'],
      icon: json['icon'],
      progress: json['progress'],
    );
  }
}
