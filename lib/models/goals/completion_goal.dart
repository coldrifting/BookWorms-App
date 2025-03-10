class CompletionGoal {
  final int avgCompletionTime;

  CompletionGoal({
    required this.avgCompletionTime
  });

  factory CompletionGoal.fromJson(Map<String, dynamic> json) {
    return CompletionGoal(
      avgCompletionTime: json['averageCompletionTime']
    );
  }
}