import 'package:bookworms_app/models/book/bookshelf.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:bookworms_app/app_state.dart';
import 'package:bookworms_app/widgets/bookshelf_widget.dart';
import 'package:bookworms_app/resources/colors.dart';
import 'package:bookworms_app/utils/widget_functions.dart';
import 'package:bookworms_app/widgets/change_child_widget.dart';

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

    AppState appState = Provider.of<AppState>(context);
    var isParent = appState.isParent;
    List<Bookshelf> bookshelves = appState.bookshelves.where((bookshelf) => bookshelf.books.length >= 3 
      && (bookshelf.type.name == "Custom" || bookshelf.type.name == "Classroom")).toList();

    return Scaffold(
      // Home app bar
      appBar: AppBar(
        systemOverlayStyle: defaultOverlay(),
        title: Text(
          "${isParent ? "${appState.children[appState.selectedChildID].name}'s" : "My"} Home",
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
          if (bookshelves.isNotEmpty) ...[
            BookshelfWidget(bookshelf: bookshelves[0]),
            addVerticalSpace(24),
          ],
          if (isParent) ... [
            _progressTracker(textTheme, appState.children[appState.selectedChildID].name),
            addVerticalSpace(24),
          ],
          ...bookshelves.skip(1).map((bookshelf) {
            return Column(
              children: [
                BookshelfWidget(bookshelf: bookshelf),
                addVerticalSpace(24),
              ],
            );
          }),
        ],
      ),
    );
  }

  /// Displays the up-to-date progress of the currently-selected child.
  /// Empty for now.
  Widget _progressTracker(TextTheme textTheme, String selectedChild) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: colorWhite,
        boxShadow: [
          BoxShadow(
            color: colorBlack.withValues(alpha: 0.2),
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
                "$selectedChild's Progress"
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