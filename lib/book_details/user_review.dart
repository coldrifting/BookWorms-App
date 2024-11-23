import 'package:flutter/material.dart';

class UserReview extends StatelessWidget {
  final String name;
  final IconData icon;
  final String role;
  final String date;
  final String reviewText;
  final String starRating;

  const UserReview({
    super.key, 
    required this.name,
    required this.icon,
    required this.role,
    required this.date,
    required this.reviewText,
    required this.starRating,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
        boxShadow: [
      BoxShadow(
        color: Colors.grey.withOpacity(0.3),
        spreadRadius: 1,
        blurRadius: 5,
      ),
    ], // Rounded corners
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(icon),
                    const SizedBox(width: 5),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        _getStarRatingText(starRating),
                      ],
                    ),
                    const SizedBox(width: 20),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200], // Background color
                        borderRadius: BorderRadius.circular(10), // Rounded corners
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 1),
                        child: Text(role),
                      ),
                    ),
                  ],
                ),
                _getDateText(date),
              ],
            ),
            Text(
              reviewText,
              textAlign: TextAlign.justify,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: (() => {}), 
                  icon: const Icon(Icons.more_horiz),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// From the numerical star rating, determines the visual string
  /// version out of 5 stars.
  Widget _getStarRatingText(String rating) {
    double numRating = double.parse(rating);
    List<Widget> stars = [];

    // The star size and color is reused, but the icon differs.
    Widget buildStarIcon(IconData data) {
      return Icon(data, size: 14, color: Colors.amber);
    }

    // Add full stars.
    for (int i = 0; i < numRating.floor(); i++) {
      stars.add(buildStarIcon(Icons.star));
    }

    // Add a half star (if applicable).
    if (numRating % 1 >= 0.5) {
      stars.add(buildStarIcon(Icons.star_half));
    }

    // Add empty stars for a total of 5 stars.
    while (stars.length < 5) {
      stars.add(buildStarIcon(Icons.star_border));
    }

    return Row(children: stars);
  }

  /// From the given date, determines the human-readable version comparative
  /// to today's date.
  Widget _getDateText(String date) {
    return const Text("1 day ago");
  }
}