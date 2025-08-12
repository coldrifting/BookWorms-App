import 'package:bookworms_app/resources/theme.dart';
import 'package:bookworms_app/utils/widget_functions.dart';
import 'package:flutter/material.dart';

/// The [NoResultsScreen] contains a message notifying the user
/// that their search yielded no results.
class NoResultsScreen extends StatelessWidget {
  const NoResultsScreen({super.key});

  /// The no results screen contains a message notifying the user
  /// that their search yielded no results.
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 50.0,
            color: context.colors.grey,
          ),
          addVerticalSpace(8),
          Text(
            "No Results",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: context.colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}