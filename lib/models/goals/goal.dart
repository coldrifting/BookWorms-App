class Goal {
  final String goalId;
  final String title;
  final String startDate;
  final String endDate;

  Goal({
    required this.goalId,
    required this.title,
    required this.startDate,
    required this.endDate,
  });

  factory Goal.fromJson(Map<String, dynamic> json) {
    return Goal(
      goalId: json['goalId'],
      title: json['title'],
      startDate: json['startDate'],
      endDate: json['endDate']
    );
  }
}