import 'package:bookworms_app/demo_books.dart';
import 'package:bookworms_app/models/book_summary.dart';
import 'package:bookworms_app/theme/colors.dart';
import 'package:bookworms_app/theme/theme.dart';
import 'package:bookworms_app/utils/widget_functions.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

/// The [RecentsScreen] displays a scrollable list of books that have been 
/// recently searched or interacted with by the user.
class RecentsScreen extends StatefulWidget {
  const RecentsScreen({super.key});

  @override
  State<RecentsScreen> createState() => _RecentsScreenState();
}

/// The state of the [RecentsScreen].
class _RecentsScreenState extends State<RecentsScreen> { 

  // Temporary for demo.
  final List<BookSummary> _books = [Demo.book1, Demo.book2, Demo.book3, Demo.book4];
  final List<String> _images = [Demo.image1, Demo.image2, Demo.image3, Demo.image4];
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
    return ListView.builder(
      itemCount: 4,
      itemBuilder: (context, index) {
        return Column(
          children: [
            ListTile(
              title: TextButton(
                style: TextButton.styleFrom(
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero
                  ),
                ),
                child: _searchResult(index, textTheme),
                onPressed: () => {},
              ),
            ),
            const Divider(
              color: colorGrey,
            )
          ],
        );
      }
    );
  }

  /// Individual book search result, including the book image and overview details.
  Widget _searchResult(int index, TextTheme textTheme) {
    BookSummary searchResult = _books[index];
    CachedNetworkImage bookImage = CachedNetworkImage(
      imageUrl: _images[index], 
      width: 150
    );
    return Row(
      children: [
        bookImage,
        addHorizontalSpace(24),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                style: textTheme.titleSmall,
                searchResult.title
              ),
              Text(
                style: textTheme.bodyMedium,
                overflow: TextOverflow.ellipsis,
                searchResult.authors.isNotEmpty 
                ? searchResult.authors.map((author) => author).join(', ')
                : "Unknown Author(s)",
              ),
            ],
          ),
        ),
      ],
    );
  }

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
                child: _scrollList(textTheme, index, _searchHeaders[index].length - 1),
              ),
              addVerticalSpace(16),
            ],
          );
        }),
      ),
    );
  }

  Widget _scrollList(TextTheme textTheme, int headerIndex, int itemCount) {
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