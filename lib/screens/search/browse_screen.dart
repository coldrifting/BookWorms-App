import 'package:flutter/material.dart';

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
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, top: 16.0),
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              "Browse By"
            ),
            _selectOption("Reading Level"),
            const SizedBox(height: 10),
            _selectOption("Topic"),
            const SizedBox(height: 10),
            _selectOption("Theme"),
            const SizedBox(height: 10),
            _selectOption("Most Popular"),
            const SizedBox(height: 10),
            _selectOption("Highest Rated"),
          ],
        ),
      ),
    );
  }

  /// A clickable "browse" option that allows a user to browse by a specific
  /// keyword.
  Widget _selectOption(String optionText) {
    return TextButton(
      onPressed: () => {},
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                optionText
              ),
              const Icon(Icons.arrow_forward_ios_rounded)
            ],
          ),
          const Divider(),
        ],
      ),
    );
  }
}