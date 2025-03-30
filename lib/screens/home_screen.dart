import 'package:bookworms_app/models/book/bookshelf.dart';
import 'package:bookworms_app/resources/theme.dart';
import 'package:bookworms_app/screens/classroom/classroom_goal_dashboard.dart';
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
  late Future<Bookshelf> _recommendedAuthorsBookshelf;
  late final Future<Bookshelf> _recommendedDescriptionsBookshelf;

  @override
  void initState() {
    super.initState();

    AppState appState = Provider.of<AppState>(context, listen: false);
    if (appState.isParent) {
      _recommendedAuthorsBookshelf = appState.getRecommendedAuthorsBookshelf(appState.selectedChildID);
      _recommendedDescriptionsBookshelf = appState.getRecommendedDescriptionsBookshelf(appState.selectedChildID);
    }
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    AppState appState = Provider.of<AppState>(context);
    var isParent = appState.isParent;

    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: defaultOverlay(),
        title: Text(
          "${isParent ? "${appState.children[appState.selectedChildID].name}'s" : "My"} Dashboard",
          style: const TextStyle(color: colorWhite)
        ),
        backgroundColor: colorGreen,
        actions: isParent ? const [
          ChangeChildWidget()
        ] : [],
      ),
      body: SingleChildScrollView(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _displayGoalProgress(textTheme),
              _displayBookshelves(textTheme),
            ],
          ),
      ),
    );
  }

  // Displays goal progress of students or current child.
  Widget _displayGoalProgress(TextTheme textTheme) {
    AppState appState = Provider.of<AppState>(context);
    var isParent = appState.isParent;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          stops: [0, 0.33],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [colorGreenGradTop, colorWhite],
        )
      ),
      child: Column(
        children: [
          addVerticalSpace(16),
          Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.sunny, color: colorWhite),
                    addHorizontalSpace(8),
                    Text("Good Day, ${appState.firstName}!", style: textTheme.titleMediumWhite),
                  ],
                ),
                Text("Check out an overview of your students' progress.", style: textTheme.bodyMediumWhite),
                addVerticalSpace(24),
              ],
            ),
          ),
          // Parent -- Child data.
          if (!isParent && appState.classroom != null) ...[
            ClassroomGoalDashboard(),
          ],
          if (isParent) ... [        
            _progressTracker(textTheme, appState.children[appState.selectedChildID].name),
            addVerticalSpace(24),
          ],
        ],
      ),
    );
  }

  // Displays curated and "large enough" (book count >= 3) custom bookshelves.
  Widget _displayBookshelves(TextTheme textTheme) {
    AppState appState = Provider.of<AppState>(context);
    var isParent = appState.isParent;
    List<Bookshelf> bookshelves = appState.bookshelves.where((bookshelf) => bookshelf.books.length >= 3 
      && (bookshelf.type.name == "Custom" || bookshelf.type.name == "Classroom")).toList();

    return Container(
      decoration: BoxDecoration(
      gradient: LinearGradient(
        stops: [0, 0.005, 0.005],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [colorGreen!, colorGreen!, colorGreenGradTop],
      )
    ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.bookmark, color: colorWhite),
                    addHorizontalSpace(8),
                    Text("Recommended for me", style: textTheme.titleMediumWhite),
                  ],
                ),
                Text("Explore your curated and personal collections", style: textTheme.bodyMediumWhite),
                addVerticalSpace(8),
              ]
            ),
          ),
          // Display recommended bookshelves for the selected child.
          if (isParent) ... [
            _getRecommendedBookshelf(_recommendedDescriptionsBookshelf),
            addVerticalSpace(24),
            _getRecommendedBookshelf(_recommendedAuthorsBookshelf),
            addVerticalSpace(24),
          ],
    
          // Custom bookshelves
          if (bookshelves.isNotEmpty)
            Column(
              children: bookshelves.map((bookshelf) {
                return Column(
                  children: [
                    BookshelfWidget(bookshelf: bookshelf),
                    addVerticalSpace(24),
                  ],
                );
              }).toList(),
            ),
          if (bookshelves.isEmpty)
            Center(
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: colorBlack.withValues(alpha: 0.2),
                          spreadRadius: 1,
                          blurRadius: 6,
                          offset: const Offset(0, 4),
                        ),
                      ],
                      borderRadius: BorderRadius.circular(4.0),
                      color: colorWhite,
                    ),
                    margin: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 28.0),
                    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                    width: 355,
                    child: SizedBox(
                      height: 100,
                      child: Center(
                        child: Text("No bookshelves to show.\nHave a nice day!", textAlign: TextAlign.center)
                      ),
                    )
                  ),
                ],
              ),
            )
        ],
      ),
    );
  }

  /// Fetches and displays the recommended bookshelf (authors, descriptions).
  Widget _getRecommendedBookshelf(Future<Bookshelf> future) {
    return FutureBuilder(
      future: future, 
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return SizedBox.shrink(); // Show nothing on error.
        } else {
          return BookshelfWidget(bookshelf: snapshot.data!);
        }
      }
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
              child: Text("$selectedChild's Progress", style: textTheme.titleMedium),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.center,
                child: Text("No progress to display", style: textTheme.bodyLarge),
              ),
            ),
          ]
        ),
      ),
    );
  }
}