class StudentGoalStatus {
  final String childName;
  final int childIcon;
  final bool hasAchievedGoal;

  StudentGoalStatus({
    required this.childName,
    required this.childIcon,
    required this.hasAchievedGoal
  });

  factory StudentGoalStatus.fromJson(Map<String, dynamic> json) {
    return StudentGoalStatus(
      childName: json['childName'],
      childIcon: json['childIcon'],
      hasAchievedGoal: json['hasAchievedGoal'],
    );
  }
}
