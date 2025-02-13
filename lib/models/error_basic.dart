class ErrorBasic {
  final String error;
  final String description;

  ErrorBasic({
    required this.error,
    required this.description
  });

  factory ErrorBasic.fromJson(Map<String, dynamic> json) {
    return ErrorBasic(
        error: json['error'],
        description: json['description']
    );
  }
}