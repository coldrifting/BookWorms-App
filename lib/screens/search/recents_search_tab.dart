import 'package:bookworms_app/app_state.dart';
import 'package:bookworms_app/theme/colors.dart';
import 'package:bookworms_app/theme/theme.dart';
import 'package:bookworms_app/utils/widget_functions.dart';
import 'package:bookworms_app/widgets/book_preview_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// The [RecentsSearchTab] displays a scrollable list of books that have been 
/// recently searched or interacted with by the user. There is also a tab for
/// querying advanced searches.
class RecentsScreen extends StatefulWidget {
  const RecentsScreen({super.key});

  @override
  State<RecentsScreen> createState() => _RecentsScreenState();
}

/// The state of the [RecentsSearchTab].
class _RecentsScreenState extends State<RecentsScreen> { 

  final List<List<String>> _searchHeaders = [["Reading Level", "A", "B", "C", "D", "E", "F", "G", "H"],
    ["Popular Topics", "Space", "Dinosaurs", "Ocean Life", "Cats", "Food", "Fairytale"],
    ["Popular Themes", "Courage", "Kindness", "Empathy", "Bravery", "Integrity", "Respect"],
    ["BookWorms Ratings", "9+", "8+", "7+", "6+"]];

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: Column(
          children: [
            TabBar(
              tabs: const [
                Tab(text: "Recents"),
                Tab(text: "Advanced Search"),
              ],
              unselectedLabelColor: colorGrey,
            ),
            Expanded(
              child: TabBarView(
                children: [
                  Center(child: _recentsWidget(textTheme)),
                  Center(child: _advancedSearchWidget(textTheme)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Recently-viewed books subpage containing a list of books.
  Widget _recentsWidget(TextTheme textTheme) {
    AppState appState = Provider.of<AppState>(context);
    var books = appState.recentlySearchedBooks;

    return ListView.builder(
      itemCount: books.length,
      itemBuilder: (context, index) {
        return Column(
          children: [
            BookPreviewListWidget(
              books: books, 
              index: books.length - index - 1
            ),
            const Divider(
              color: colorGrey,
            )
          ],
        );
      }
    );
  }

  // Contains advanced filters for searching.
  Widget _advancedSearchWidget(TextTheme textTheme) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(4, (index) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _searchHeaders[index][0],
                style: textTheme.titleMedium,
              ),
              addVerticalSpace(8),
              SizedBox(
                height: 45,
                child: _filterScrollList(textTheme, index, _searchHeaders[index].length - 1),
              ),
              addVerticalSpace(16),
            ],
          );
        }),
      ),
    );
  }

  // Horizontal list of scrollable filters.
  Widget _filterScrollList(TextTheme textTheme, int headerIndex, int itemCount) {
    return ListView.builder(
      itemCount: itemCount,
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: colorGreen,
              border: Border.all(color: Colors.transparent),
              borderRadius: BorderRadius.circular(4),
            ),
            //color: colorGreen,
            alignment: Alignment.center,
            child: TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(padding: EdgeInsets.zero),
              child: Text(
                _searchHeaders[headerIndex][index + 1],
                style: textTheme.bodyLargeWhite,
              ),
            ),
          ),
        );
      },
    );
  }
}