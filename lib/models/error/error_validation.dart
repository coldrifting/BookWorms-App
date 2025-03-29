class ErrorValidation {
  final Map<String, dynamic> errors;

  ErrorValidation({
    required this.errors
  });

  factory ErrorValidation.fromJson(Map<String, dynamic> json) {
    return ErrorValidation(
      errors: json['errors'],
    );
  }
}