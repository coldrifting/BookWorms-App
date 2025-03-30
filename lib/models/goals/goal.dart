class Goal {
  final String goalId;
  final String goalType;
  final String goalMetric;
  final String title;
  final String startDate;
  final String endDate;
  final int target;
  final int progress;

  Goal({
    required this.goalId,
    required this.goalType,
    required this.goalMetric,
    required this.title,
    required this.startDate,
    required this.endDate,
    required this.target,
    required this.progress
  });

  factory Goal.fromJson(Map<String, dynamic> json) {
    return Goal(
      goalId: json['goalId'],
      goalType: json['goalType'],
      goalMetric: json['goalMetric'],
      title: json['title'],
      startDate: json['startDate'],
      endDate: json['endDate'],
      progress: json['progress'],
      target: json['target']
    );
  }
}