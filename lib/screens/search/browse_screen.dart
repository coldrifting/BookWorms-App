import 'package:flutter/material.dart';

import 'package:bookworms_app/utils/widget_functions.dart';

/// The [BrowseScreen] contains a few options for browsing by a specific keyword.
/// For example, a user is able to browse by "reading level", "topic", "theme", etc.
class BrowseScreen extends StatefulWidget {
  const BrowseScreen({super.key});

  @override
  State<BrowseScreen> createState() => _BrowseScreenState();
}

/// The state of the [BrowseScreen].
class _BrowseScreenState extends State<BrowseScreen> { 
  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.only(
        left: 16.0,
        top: 16.0
      ),
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              style: textTheme.headlineSmall,
              "Browse By"
            ),
            addVerticalSpace(10),
            _selectOption("Reading Level", textTheme),
            addVerticalSpace(10),
            _selectOption("Topic", textTheme),
            addVerticalSpace(10),
            _selectOption("Theme", textTheme),
            addVerticalSpace(10),
            _selectOption("Most Popular", textTheme),
            addVerticalSpace(10),
            _selectOption("Highest Rated", textTheme),
          ],
        ),
      ),
    );
  }

  /// A clickable "browse" option that allows a user to browse by a specific
  /// keyword.
  Widget _selectOption(String optionText, TextTheme textTheme) {
    return Column(
      children: [
        TextButton(
          onPressed: () => {},
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                style: textTheme.titleSmall,
                optionText
              ),
              const Icon(Icons.arrow_forward_ios_rounded)
            ],
          ),
        ),
        const Divider(),
      ],
    );
  }
}