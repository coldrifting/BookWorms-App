class NumBooksGoal {
  final int targetNumBooks;
  final int avgBooksRead;

  NumBooksGoal({
    required this.targetNumBooks,
    required this.avgBooksRead
  });

  factory NumBooksGoal.fromJson(Map<String, dynamic> json) {
    return NumBooksGoal(
      targetNumBooks: json['targetNumBooks'],
      avgBooksRead: json['avageBooksRead']
    );
  }
}