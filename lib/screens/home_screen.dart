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
    List<Bookshelf> bookshelves = appState.bookshelves.where((bookshelf) => bookshelf.books.length >= 3 
      && (bookshelf.type.name == "Custom" || bookshelf.type.name == "Classroom")).toList();

    return Scaffold(
      // Home app bar
      appBar: AppBar(
        systemOverlayStyle: defaultOverlay(),
        title: Text(
          "${isParent ? "${appState.children[appState.selectedChildID].name}'s" : "My"} Dashboard",
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
          Container(      
            decoration: BoxDecoration(
              gradient: LinearGradient(
                stops: [0, 0.2, 0.51, 0.58],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [colorGreenGradTop, colorWhite, colorWhite, colorGreenGradTop],
              )
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                addVerticalSpace(16),
                Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Good Day, ${appState.firstName}!", style: textTheme.titleMediumWhite),
                      Text("Check out an overview of your students' progress.", style: textTheme.bodyMediumWhite),
                      addVerticalSpace(24),
                    ],
                  ),
                ),
              if (!isParent && appState.classroom != null) ...[
                _teacherProgressData(),
                addVerticalSpace(24),
              ],

              if (isParent) ... [        
                // Progress/goal tracker overview.
                _progressTracker(textTheme, appState.children[appState.selectedChildID].name),
                addVerticalSpace(24),
                      
                // Recommended bookshelf (similar descriptions).
                _getRecommendedBookshelf(_recommendedDescriptionsBookshelf),
                addVerticalSpace(24),
              
                // Recommended bookshelf (similar authors).
                _getRecommendedBookshelf(_recommendedAuthorsBookshelf),
                addVerticalSpace(24),
              ],

              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Recommended for me", style: textTheme.titleMediumWhite),
                    Text("Get a glimpse of your curated bookshelves.", style: textTheme.bodyMediumWhite),
                    addVerticalSpace(16),
                  ],
                ),
              ),
                      
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
              ],
            ),
          ),
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

  Widget _teacherProgressData() {
    return ClassroomGoalDashboard();
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