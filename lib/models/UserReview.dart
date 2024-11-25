/// User review data appearing on the book details screen.
class UserReview {
  //final String name;
  final String username;
  //final IconData icon;
  //final String role;
  //final String date;
  final String text;
  final double starRating;

  const UserReview({
    //required this.name,
    required this.username,
    //required this.icon,
    //required this.role,
    //required this.date,
    required this.text,
    required this.starRating,
  });

  // Decodes the JSON to create a Review object.
  factory UserReview.fromJson(Map<String, dynamic> json) {
    return UserReview(
      //name: json['name'],
      username: json['reviewerUsername'],
      //icon: json['icon'],
      //role: json['role'],
      //date: json['date'],
      starRating: (json['starRating'] as num).toDouble(),
      text: json['reviewText']
    );
  }
}