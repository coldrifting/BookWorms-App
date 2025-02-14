import 'package:bookworms_app/app_state.dart';
import 'package:bookworms_app/models/bookshelf.dart';
import 'package:bookworms_app/models/child.dart';
import 'package:bookworms_app/theme/colors.dart';
import 'package:bookworms_app/utils/widget_functions.dart';
import 'package:bookworms_app/widgets/change_child_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart'; // Books used for the demo

/// The [BookshelvesScreen] contains a user's curated/personal bookshelves. The
/// user is able to add a new bookshelf here, or access their current bookshelves.
class BookshelvesScreen extends StatefulWidget {
  const BookshelvesScreen({super.key});

  @override
  State<BookshelvesScreen> createState() => _BookshelvesScreenState();
}

/// The state of [BookshelvesScreen].
class _BookshelvesScreenState extends State<BookshelvesScreen> { 
  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    AppState appState = Provider.of<AppState>(context);
    Child selectedChild = appState.children[appState.selectedChildID];

    if (selectedChild.bookshelves.isEmpty) {
      appState.setChildBookshelves(appState.selectedChildID);
    }
    List<Bookshelf> bookshelves = selectedChild.bookshelves;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "${selectedChild.name}'s Bookshelves",
            style: const TextStyle(
              color: colorWhite
            )
          ),
          backgroundColor: colorGreen,
          actions: const [ChangeChildWidget()],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _createBookshelfWidget(textTheme),
              Expanded(
                child: ListView.builder(
                  itemCount: bookshelves.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        addVerticalSpace(16),
                        _bookshelfWidget(bookshelves[index]),
                      ],
                    );
                  }
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// The labeled button for creating a bookshelf.
  Widget _createBookshelfWidget(TextTheme textTheme) {
    return Container(
      decoration: BoxDecoration(
        color: colorGreyLight,
        border: Border.all(color: colorGreyDark ?? colorBlack),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButton(
            onPressed: () => {}, 
            icon: const Icon(Icons.add)
          ),
          addHorizontalSpace(10),
          Text(
            style: textTheme.titleMedium,
            "Create New Bookshelf"
          ),
        ],
      ),
    );
  }

  /// A bookshelf includes the title, book cover(s), and author(s).
  Widget _bookshelfWidget(Bookshelf bookshelf) {
    AppState appState = Provider.of<AppState>(context);
    Color mainColor = Colors.grey[200]!; // Temporary
    Color accentColor = Colors.grey[800]!; // Temporary

    return Dismissible(
      key: ValueKey(bookshelf.name), // Bookshelf names are unique.
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) async {
        appState.deleteChildBookshelf(appState.selectedChildID, bookshelf);
        return true;
      },
      background: TextButton(
        style: TextButton.styleFrom(backgroundColor: Colors.red),
        onPressed: () {}, 
        child: Text("Delete me!"),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: mainColor,
          border: Border.all(color: accentColor),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: _imageLayoutWidget(bookshelf),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      bookshelf.name
                    ),
                    Text(
                      style: const TextStyle(fontSize: 14, overflow: TextOverflow.ellipsis),
                      _printFirstAuthors(bookshelf, 2),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Displays some of the book cover(s) in the bookshelf. Each image is 
  /// laid out diagonally across the container.
  Widget _imageLayoutWidget(Bookshelf bookshelf) {
    var bookCovers = bookshelf.books.take(3).map((book) => book.image).where((image) => image != null).toList();

    return SizedBox(
      width: 100, 
      height: 100,
      child: LayoutBuilder(
        builder:(context, constraints) {
          if (bookCovers.isEmpty) {
            return Align(
              child: SizedBox(
                height: constraints.maxHeight * 0.7,
                child: SvgPicture.asset('assets/images/bookworms_logo.svg'),
              ),
            );
          } else {
            return Stack(
              children: [
                Align(
                    alignment: Alignment.center,
                    child: SizedBox(
                      height: constraints.maxHeight * 0.5,
                      child: bookCovers[0],
                    ),
                  ),
                if (bookCovers.length > 1)
                  Positioned( // Top cover image
                    top: 5,
                    left: 5,
                    child: SizedBox(
                      height: constraints.maxHeight * 0.5,
                      child: bookCovers[1],
                    ),
                  ),
                if (bookCovers.length > 2)
                  Positioned( // Bottom cover image
                    bottom: 5,
                    right: 5,
                    child: SizedBox(
                      height: constraints.maxHeight * 0.5,
                      child: bookCovers[2],
                    ),
                  ),
              ],
            );
          }
        },
      ),
    );
  }

  // Prints the first 'count' of authors.
  String _printFirstAuthors(Bookshelf bookshelf, int count) {
    var authors = bookshelf.books.expand((book) => book.authors).take(count);
    return authors.length < count
      ? authors.join(", ")
      : "${authors.join(", ")}, and more";
  }
}