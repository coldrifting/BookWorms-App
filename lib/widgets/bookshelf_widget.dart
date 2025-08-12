import 'package:bookworms_app/models/book/book_details.dart';
import 'package:bookworms_app/models/book/bookshelf.dart';
import 'package:bookworms_app/resources/theme.dart';
import 'package:bookworms_app/screens/book_details/book_details_screen.dart';
import 'package:bookworms_app/screens/bookshelves/bookshelf_screen.dart';
import 'package:bookworms_app/services/book/book_details_service.dart';
import 'package:bookworms_app/utils/widget_functions.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:bookworms_app/models/book/book_summary.dart';

/// The [BookshelfWidget] displays an overview of a user's bookshelf. It
/// includes a short display of book covers, the bookshelf title, and some
/// authors present in the bookshelf.
class BookshelfWidget extends StatefulWidget {
  final Bookshelf bookshelf;

  const BookshelfWidget({
    super.key, 
    required this.bookshelf
  });

  @override
  State<BookshelfWidget> createState() => _BookshelfWidget();
}

class _BookshelfWidget extends State<BookshelfWidget> {
  late BookDetailsService _bookDetailsService;

  @override
  void initState() {
    super.initState();
    _bookDetailsService = BookDetailsService();
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    Bookshelf bookshelf = widget.bookshelf;

    return Container(
      // Bookshelf shadow
      decoration: BoxDecoration(
        color: context.colors.surface,
        boxShadow: [
          BoxShadow(
            color: context.colors.surfaceBorder.withAlpha(64),
            spreadRadius: 2,
            blurRadius: 2,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
          if (mounted) {
            // Change the screen to the "bookshelf" screen.
            pushScreen(context, BookshelfScreen(bookshelf: bookshelf));
          }
        },
        child: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: context.colors.surface,
                  boxShadow: [
                    BoxShadow(
                      color: context.colors.surfaceBorder.withAlpha(128),
                      blurRadius: 2,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Stack(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(widget.bookshelf.name, style: textTheme.titleLarge),
                          ],
                        ),
                        Positioned(
                          right: 10,
                          child: Icon(Icons.arrow_forward, color: context.colors.greyDark)
                        )
                      ]
                    ),
                    addVerticalSpace(4),
                  ],
                ),
              ),
              // List of bookshelf books
              SizedBox(
                height: 250,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    for (int i = 0; i < widget.bookshelf.books.length; i++) ...[
                      InkWell(
                        child: _bookPreview(book: widget.bookshelf.books[i], textTheme: textTheme),
                        onTap: () async {
                          onBookClicked(widget.bookshelf.books[i]);
                        }
                      ),
                      // Add the divider on every book but the last.
                      if (i < widget.bookshelf.books.length - 1) ...[
                        const VerticalDivider()
                      ]
                    ]
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: context.colors.surface,
                  boxShadow: [
                    BoxShadow(
                      color: context.colors.surfaceBorder.withAlpha(128),
                      blurRadius: 2,
                      offset: Offset(0, -2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        addVerticalSpace(12),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void onBookClicked(BookSummary book) async {
    BookDetails results = await _bookDetailsService.getBookDetails(book.id);

    if (mounted) {
      // Change the screen to the "book details" screen.
      pushScreen(context, BookDetailsScreen(summaryData: book, detailsData: results));
    }
  }

  /// Displays book summary information with the book cover, title, author, 
  /// rating, and difficulty.
  Widget _bookPreview({required BookSummary book, required TextTheme textTheme}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            // Cover image
            child: CachedNetworkImage(
              height: 160,
              imageUrl: book.imageUrl!,
              placeholder: (context, url) => Center(child: CircularProgressIndicator()),
              errorWidget: (context, url, error) => Image.asset("assets/images/book_cover_unavailable.jpg"),
            )
          ),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 225),
            child: Column(
              children: [
                // Book title
                Text(
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 14, 
                    fontWeight: FontWeight.bold, 
                    overflow: TextOverflow.ellipsis, 
                    height: 1.2,
                  ),
                  book.title,
                ),
                // Book author
                Text(
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 12, overflow: TextOverflow.ellipsis), 
                  maxLines: 1,
                  book.authors.isNotEmpty 
                  ? book.authors.map((author) => author).join(', ')
                  : "Unknown Author(s)",
                ),
                // Book rating and difficulty
                if (book.rating != null && book.level != null) ...[
                  Text(
                    textAlign: TextAlign.center,
                    style: textTheme.bodySmall, 
                    "${book.rating != null ? "${book.rating}★" : ""}   ${book.level != null ? "level ${book.level}" : ""}"
                  ),
                ]
                else if (book.rating != null || book.level != null) ...[
                  Text(
                    textAlign: TextAlign.center,
                    style: textTheme.bodySmall, 
                    book.rating == null ? "${book.level}" : "${book.rating}★"
                  ),
                ]
              ],
            ),
          ),
        ],
      ),
    );
  }
}