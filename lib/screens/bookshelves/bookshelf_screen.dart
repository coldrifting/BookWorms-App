import 'package:bookworms_app/app_state.dart';
import 'package:bookworms_app/models/book_details.dart';
import 'package:bookworms_app/models/book_summary.dart';
import 'package:bookworms_app/models/bookshelf.dart';
import 'package:bookworms_app/models/child.dart';
import 'package:bookworms_app/resources/colors.dart';
import 'package:bookworms_app/screens/book_details/book_details_screen.dart';
import 'package:bookworms_app/services/book/book_details_service.dart';
import 'package:bookworms_app/utils/widget_functions.dart';
import 'package:bookworms_app/widgets/change_child_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

/// The [BookshelfScreen] contains a list of books of the bookshelf.
class BookshelfScreen extends StatefulWidget {
  final Bookshelf bookshelf;

  const BookshelfScreen({
    super.key,
    required this.bookshelf,
  });

  @override
  State<BookshelfScreen> createState() => _BookshelfScreenState();
}

/// The state of [BookshelfScreen].
class _BookshelfScreenState extends State<BookshelfScreen> {
  late Bookshelf bookshelf;
  late BookDetailsService _bookDetailsService;

  @override
  void initState() {
    super.initState();
    bookshelf = widget.bookshelf;
    _bookDetailsService = BookDetailsService();
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    AppState appState = Provider.of<AppState>(context);
    Child selectedChild = appState.children[appState.selectedChildID];
    List<BookSummary> books = bookshelf.books;

    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: defaultOverlay(),
        title: Text(
          "${selectedChild.name}'s Bookshelves", 
          style: TextStyle(
            color: colorWhite, 
            overflow: TextOverflow.ellipsis
          )
        ),
        backgroundColor: colorGreen,
        leading: IconButton(
          color: colorWhite,
          icon: const Icon(Icons.arrow_back),
          onPressed: () { Navigator.of(context).pop(); },
        ),
        actions: const [ChangeChildWidget()], // TO DO: On changing child, return to bookshelves screen.
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: ListView.builder(
          itemCount: books.length + 1,
          itemBuilder: (context, index) {
            if (index == 0) {
              return Column(
                children: [
                  addVerticalSpace(16),
                  Row(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(bookshelf.name, style: textTheme.titleMedium),
                      ),
                      IconButton(icon: Icon(Icons.more_horiz), onPressed: () {}),
                    ],
                  ),
                ],
              );
            } else {
              return Column(
                children: [
                  addVerticalSpace(16),
                  InkWell(
                    onTap: () { onBookClicked(books[index - 1]); },
                    child: _bookshelfWidget(textTheme, books[index - 1])
                  ),
                ],
              );
            }
          }
        ),
      ),
    );
  }

  // When clicking a book widget, navigates to the [BookDetailsScreen].
  void onBookClicked(BookSummary book) async {
    BookDetails results = await _bookDetailsService.getBookDetails(book.id);
    if (mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BookDetailsScreen(summaryData: book, detailsData: results)
        )
      );
    }
  }

  // Displays the book summary data and includes a slider functionality to delete books.
  Widget _bookshelfWidget(TextTheme textTheme, BookSummary book) {
    AppState appState = Provider.of<AppState>(context);
    return Slidable(
      key: UniqueKey(),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        dismissible: DismissiblePane(
          onDismissed: () { 
            appState.removeBookFromBookshelf(appState.selectedChildID, bookshelf, book.id);
            setState(() {
              bookshelf.books.removeWhere((b) => b.id == book.id);
            });
          },
        ),
        children: [
          SlidableAction(
            onPressed: (BuildContext context) { 
              appState.removeBookFromBookshelf(appState.selectedChildID, bookshelf, book.id);
              setState(() {
                bookshelf.books.removeWhere((b) => b.id == book.id);
              });
            },
            backgroundColor: colorRed!,
            foregroundColor: colorWhite,
            borderRadius: BorderRadius.circular(4),
            icon: Icons.delete,
            label: 'Delete',
          ),
        ],
      ),
      child: Container(
        decoration: BoxDecoration(
          color: colorGreyLight,
          border: Border.all(color: Colors.grey[200]!),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: 150,
                child: CachedNetworkImage(
                  imageUrl: book.imageUrl!,
                  placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => Image.asset("assets/images/book_cover_unavailable.jpg"),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      book.title
                    ),
                    Text(
                      style: const TextStyle(fontSize: 14, overflow: TextOverflow.ellipsis),
                      printFirstAuthors(book.authors, 2),
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
}