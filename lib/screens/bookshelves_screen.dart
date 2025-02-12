import 'package:bookworms_app/app_state.dart';
import 'package:bookworms_app/models/bookshelf.dart';
import 'package:bookworms_app/models/child.dart';
import 'package:bookworms_app/theme/colors.dart';
import 'package:bookworms_app/utils/widget_functions.dart';
import 'package:bookworms_app/widgets/change_child_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:bookworms_app/demo_books.dart';
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
    int selectedChildID = appState.selectedChildID;
    Child selectedChild = appState.children[selectedChildID];
    List<Bookshelf> bookshelves = appState.bookshelves;

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
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                _createBookshelfWidget(textTheme),
                ListView.builder(
                  itemCount: bookshelves.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        addVerticalSpace(16),
                        _bookshelfWidget(
                          bookshelves[index]
                        ),
                      ],
                    );
                  }
                ),
              ],
            ),



          // child: ListView(
          //   children: [
          //     addVerticalSpace(16),
          //     _createBookshelfWidget(textTheme),
          //     addVerticalSpace(16),
          //     _bookshelfWidget(
          //       Bookshelf(name: "Recommended Books", books: []),
          //       [Demo.image1, Demo.image2, Demo.image3],
          //       [Demo.authors1, Demo.authors2, Demo.authors3],
          //       Colors.yellow[200],
          //       Colors.yellow[800]
          //     ),
          //     addVerticalSpace(16),
          //     _bookshelfWidget(
          //       Bookshelf(name: "Ms. Wilson's Class Reading List", books: []),
          //       [Demo.image4, Demo.image5, Demo.image6],
          //       [Demo.authors4, Demo.authors5, Demo.authors6],
          //       Colors.red[200],
          //       Colors.red[800]
          //     ),
          //     addVerticalSpace(16),
          //     _bookshelfWidget(
          //       Bookshelf(name: "Currently Reading", books: []),
          //       [Demo.image6, Demo.image8, Demo.image9],
          //       [Demo.authors6, Demo.authors8, Demo.authors9],
          //       Colors.blue[200],
          //       Colors.blue[800]
          //     ),
          //     addVerticalSpace(16),
          //     _bookshelfWidget(
          //       Bookshelf(name: "Completed Books", books: []),
          //       [Demo.image5, Demo.image10, Demo.image4],
          //       [Demo.authors5, Demo.authors10, Demo.authors4],
          //       Colors.green[200],
          //       Colors.green[800]
          //     ),
          //     addVerticalSpace(16),
          //     _bookshelfWidget(
          //       Bookshelf(name: "Animals", books: []),
          //       [Demo.image2, Demo.image5, Demo.image6],
          //       [Demo.authors2, Demo.authors5, Demo.authors6],
          //       Colors.grey[200],
          //       Colors.grey[800]
          //     ),
          //     addVerticalSpace(16),
          //     _bookshelfWidget(
          //       Bookshelf(name: "Fairytales", books: []),
          //       [Demo.image8, Demo.image9, Demo.image7],
          //       [Demo.authors8, Demo.authors9, Demo.authors7],
          //       Colors.grey[200],
          //       Colors.grey[800]
          //     ),
          //     addVerticalSpace(16),
          //   ],
          // ),
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
          return Stack(
            children: [
              Positioned( // Top cover image
                top: 5,
                left: 5,
                child: SizedBox(
                  height: constraints.maxHeight * 0.5,
                  child: bookCovers[0],
                ),
              ),
              if (bookCovers.length > 1)
                Align(
                  alignment: Alignment.center,
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