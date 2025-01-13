import 'package:bookworms_app/demo_books.dart';
import 'package:bookworms_app/models/book_summary.dart';
import 'package:bookworms_app/theme/colors.dart';
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
              labelColor: colorGreen,
              unselectedLabelColor: colorGrey,
              indicatorColor: colorGreen,
            ),
            Expanded(
              child: TabBarView(
                children: [
                  Center(child: _recentsWidget(textTheme)),
                  const Center(child: Text("Advanced Search")),
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
                child: searchResult(index, textTheme),
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
  Widget searchResult(int index, TextTheme textTheme) {
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
}