import 'package:flutter/material.dart';

import 'package:bookworms_app/models/user_review.dart';
import 'package:bookworms_app/utils/user_icons.dart';
import 'package:bookworms_app/resources/colors.dart';
import 'package:bookworms_app/utils/widget_functions.dart';

/// The [ReviewWidget] captures a single user corresponding to a specific
/// book. A user review contains the user's icon, name, role, star rating,
/// review text, and the date of the review.
class ReviewWidget extends StatelessWidget {
  final UserReview review;

  const ReviewWidget({
    super.key, 
    required this.review
  });

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Container(
      decoration: BoxDecoration(
        color: colorWhite,
        borderRadius: BorderRadius.circular(4),
        boxShadow: [
          BoxShadow(
            color: colorGrey.withValues(alpha: 0.3),
            spreadRadius: 1,
            blurRadius: 5,
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                _buildHeader(textTheme),
                addVerticalSpace(6),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    review.text,
                  ),
                ),
              ],
            ),
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
    );
  }

  /// From the numerical star rating, determines the visual string version.
  Widget _buildStarRating(double rating) {
    // The star size and color is reused, but the icon differs.
    Widget buildStarIcon(IconData data) {
      return Icon(data, size: 14, color: colorYellow);
    }

    return Row(children: 
      List.generate(5, (index) {
        if (index + 1 <= rating.floor()) {
          return buildStarIcon(Icons.star);
        } else if (index < rating) {
          return buildStarIcon(Icons.star_half);
        } else {
          return buildStarIcon(Icons.star_border);
        }
      })
    );
  }

  /// The review header containing icon, username, star rating, role, and date.
  Widget _buildHeader(TextTheme textTheme) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            UserIcons.getRandomIcon(),
            addHorizontalSpace(5),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  review.firstName,
                  style: textTheme.titleSmall,
                ),
                _buildStarRating(review.starRating),
              ],
            ),
            addHorizontalSpace(20),
            _buildRole(),
          ],
        ),
        _buildDate("Date"), // Temporary date
      ],
    );
  }

  /// Constructs a widget for the user's role.
  Widget _buildRole() {
    return Container(
      decoration: BoxDecoration(
        color: colorGreyLight,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
        child: Text(review.role),
      ),
    );
  }

  /// From the given date, determines the human-readable version comparative
  /// to today's date. Right now, it returns a default string.
  Widget _buildDate(String date) {
    return const Text("");
  }
}