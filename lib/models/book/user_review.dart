/// User review data appearing on the book details screen.
class UserReview {
  final String firstName;
  final String lastName;
  final String role;
  final int icon;
  final String text;
  final double starRating;
  final String date;

  const UserReview({
    required this.firstName,
    required this.lastName,
    required this.role,
    required this.icon,
    required this.text,
    required this.starRating,
    required this.date
  });

  // Decodes the JSON to create a Review object.
  factory UserReview.fromJson(Map<String, dynamic> json) {
    return UserReview(
      firstName: json['reviewerFirstName'],
      lastName: json['reviewerLastName'],
      role: json['reviewerRole'],
      icon: json['reviewerIcon'],
      starRating: (json['starRating'] as num).toDouble(),
      text: json['reviewText'],
      date: json['reviewDate']
    );
  }
}