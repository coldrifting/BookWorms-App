//import 'package:bookworms_app/models/BookSummary.dart';
import 'package:bookworms_app/app_state.dart';
import 'package:bookworms_app/widgets/bookshelf_widget.dart';
import 'package:bookworms_app/theme/colors.dart';
import 'package:bookworms_app/utils/widget_functions.dart';
import 'package:bookworms_app/widgets/change_child_widget.dart';
import 'package:flutter/material.dart';
// Books used for the demo
import 'package:bookworms_app/demo_books.dart';
import 'package:provider/provider.dart';

/// The [HomeScreen] contains an overview of the selected child's app data.
/// Specifically, it displays curated and personal bookshelves, as well as the
/// child's progress toward goals.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

/// The state of the [HomeScreen].
class _HomeScreenState extends State<HomeScreen> {

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    var isParent = Provider.of<AppState>(context, listen: false).isParent;
    return SafeArea(
      child: Scaffold(
        // Home app bar
        appBar: AppBar(
          title: Text(
            "${isParent ? "${Provider.of<AppState>(context).children[Provider.of<AppState>(context).selectedChildID].name}'s" : "My"} Home",
            style: const TextStyle(
              color: colorWhite
            )
          ),
          backgroundColor: colorGreen,
          actions: isParent ? const [
            ChangeChildWidget()
          ] : [],
        ),
        // Bookshelves list
        body: ListView(
          children: [
            addVerticalSpace(16),
            BookshelfWidget(name: "Recommended", images: [Demo.image1, Demo.image2, Demo.image3, Demo.image4], books: [Demo.book1, Demo.book2, Demo.book3, Demo.book4]),
            addVerticalSpace(24),
            if (isParent) ... [
              _progressTracker(textTheme),
              addVerticalSpace(24),
            ],
            BookshelfWidget(name: "Animals", images: [Demo.image2, Demo.image5, Demo.image6, Demo.image7], books: [Demo.book2, Demo.book5, Demo.book6, Demo.book7]),
            addVerticalSpace(24),
            BookshelfWidget(name: "Fairytales", images: [Demo.image8, Demo.image9, Demo.image7, Demo.image10], books: [Demo.book8, Demo.book9, Demo.book7, Demo.book10]),
            addVerticalSpace(16),
          ],
        ),
      ),
    );
  }

  /// Displays the up-to-date progress of the currently-selected child.
  /// Empty for now.
  Widget _progressTracker(TextTheme textTheme) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: colorWhite,
        boxShadow: [
          BoxShadow(
            color: colorBlack.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 6,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                style: textTheme.titleMedium,
                "Johnny's Progress"
              ),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  style: textTheme.bodyLarge,
                  "No progress to display"
                ),
              ),
            ),
          ]
        ),
      ),
    );
  }
}