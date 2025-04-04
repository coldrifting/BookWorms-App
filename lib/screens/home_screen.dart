import 'package:bookworms_app/app_state.dart';
import 'package:bookworms_app/models/book/bookshelf.dart';
import 'package:bookworms_app/resources/colors.dart';
import 'package:bookworms_app/resources/theme.dart';
import 'package:bookworms_app/screens/goals/goal_dashboard.dart';
import 'package:bookworms_app/showcase/showcase_controller.dart';
import 'package:bookworms_app/showcase/showcase_widgets.dart';
import 'package:bookworms_app/utils/widget_functions.dart';
import 'package:bookworms_app/widgets/app_bar_custom.dart';
import 'package:bookworms_app/widgets/bookshelf_widget.dart';
import 'package:flutter/material.dart';
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
  late Future<Bookshelf> _recommendedAuthorsBookshelf;
  late final Future<Bookshelf> _recommendedDescriptionsBookshelf;
  late bool existsRecommended;
  late final showcaseController = ShowcaseController();
  late final List<GlobalKey> navKeys = showcaseController.getKeysForScreen('home');

  @override
  void initState() {
    super.initState();

    AppState appState = Provider.of<AppState>(context, listen: false);
    var isParent = appState.isParent;
    existsRecommended = false;

    int? childId = isParent ? appState.selectedChildID : null;
    _recommendedAuthorsBookshelf = appState.getRecommendedAuthorsBookshelf(childId);
    _recommendedDescriptionsBookshelf = appState.getRecommendedDescriptionsBookshelf(childId);

    // Start showcase when Home Screen loads,
    //  but only if this is the first time launching the app
    appState.isFirstLaunch().then((isFirstLaunch) {
      if (isFirstLaunch) {
        WidgetsBinding.instance.addPostFrameCallback(
                (_) => showcaseController.start()
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    AppState appState = Provider.of<AppState>(context);
    var isParent = appState.isParent;

    String headerTitle = "${isParent
        ? "${appState.children[appState.selectedChildID].name}'s"
        : "My"} Dashboard";

    return Scaffold(
      appBar: AppBarCustom(headerTitle, isLeafPage: false, isChildSwitcherEnabled: true, homePageShowcaseKey: navKeys[0]),
      body: SingleChildScrollView(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BWShowcase(
                showcaseKey: isParent ? navKeys[1] : navKeys[0],
                description: "View upcoming goals for your ${isParent ? "child" : "class"} here",
                child: _displayGoalProgress(textTheme)
              ),
              BWShowcase(
                showcaseKey: isParent ? navKeys[2] : navKeys[1],
                description: "Book lists for your ${isParent ? "child" : "class"} will appear here",
                child: _displayBookshelves(textTheme)
              ),
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
          stops: [0, 0.4],
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
                Text(
                  "Check out an overview of ${isParent ? "${appState.children[appState.selectedChildID].name}'s" : "your students'"} progress",
                  style: textTheme.bodyMediumWhite
                ),
                addVerticalSpace(24),
              ],
            ),
          ),
          // Parent -- Child data.
          if (isParent || (!isParent && appState.classroom != null)) ...[
            GoalDashboard(),
          ],
        ],
      ),
    );
  }

  // Displays curated and "large enough" (book count >= 3) custom bookshelves.
  Widget _displayBookshelves(TextTheme textTheme) {
    AppState appState = Provider.of<AppState>(context);
    List<Bookshelf> bookshelves = appState.bookshelves.where((bookshelf) => bookshelf.books.length >= 3 
      && (bookshelf.type.name == "Custom" || bookshelf.type.name == "Classroom")).toList();

    return Container(
      decoration: BoxDecoration(
      gradient: LinearGradient(
        stops: [0, 0.005, 0.005],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [colorGreen, colorGreen, colorGreenGradTop],
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
          // Display recommended bookshelves.
          _getRecommendedBookshelf(_recommendedDescriptionsBookshelf),
          _getRecommendedBookshelf(_recommendedAuthorsBookshelf),
    
          // Display custom bookshelves.
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
          if (!existsRecommended && bookshelves.isEmpty)
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
                  addVerticalSpace(32),
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
        } else if (snapshot.hasError || snapshot.data!.books.isEmpty) {
          return SizedBox.shrink();
        } else {
          existsRecommended = true;
          return Column(
            children: [
              BookshelfWidget(bookshelf: snapshot.data!),
              addVerticalSpace(24)
            ],
          );
        }
      }
    );
  }
}