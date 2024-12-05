/// User review data appearing on the book details screen.
class UserReview {
  final String name;
  final String role;
  final String icon;
  final String text;
  final double starRating;

  const UserReview({
    required this.name,
    required this.role,
    required this.icon,
    required this.text,
    required this.starRating,
  });

  // Decodes the JSON to create a Review object.
  factory UserReview.fromJson(Map<String, dynamic> json) {
    return UserReview(
      name: json['reviewerName'],
      role: json['reviewerRole'],
      icon: json['reviewerIcon'],
      starRating: (json['starRating'] as num).toDouble(),
      text: json['reviewText']
    );
  }
}