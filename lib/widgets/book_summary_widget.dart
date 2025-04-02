import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:bookworms_app/app_state.dart';
import 'package:bookworms_app/models/book/book_details.dart';
import 'package:bookworms_app/models/book/book_summary.dart';
import 'package:bookworms_app/screens/book_details/book_details_screen.dart';
import 'package:bookworms_app/services/book/book_details_service.dart';
import 'package:bookworms_app/utils/widget_functions.dart';

class BookSummaryWidget extends StatefulWidget {
  final BookSummary book;

  const BookSummaryWidget({
    super.key,
    required this.book
  });

  @override
  State<BookSummaryWidget> createState() => _BookSummaryWidgetState();
}

class _BookSummaryWidgetState extends State<BookSummaryWidget> {
  late BookDetailsService _bookDetailsService;

  @override
  void initState() {
    super.initState();
    _bookDetailsService = BookDetailsService();
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    AppState appState = Provider.of<AppState>(context);
    
    BookSummary book = widget.book;
    String bookImage = book.imageUrl!;

    return ListTile(
      title: TextButton(
        style: TextButton.styleFrom(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.zero
          ),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 150,
              child: CachedNetworkImage(
                imageUrl: bookImage,
                placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                errorWidget: (context, url, error) => Image.asset("assets/images/book_cover_unavailable.jpg"),
              ),
            ),
            addHorizontalSpace(24),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    style: textTheme.titleSmall,
                    book.title
                  ),
                  Text(
                    style: textTheme.bodyMedium,
                    overflow: TextOverflow.ellipsis,
                    book.authors.isNotEmpty 
                    ? book.authors.map((author) => author).join(', ')
                    : "Unknown Author(s)",
                  ),
                  if (book.rating != null && book.level != null) ...[
                    Text(
                      textAlign: TextAlign.center,
                      style: textTheme.bodyMedium, 
                      "${book.rating != null ? "${book.rating}★" : ""} ${book.level != null ? "${book.level}" : ""}"
                    ),
                  ]
                  else if (book.rating != null || book.level != null) ...[
                    Text(
                      textAlign: TextAlign.center,
                      style: textTheme.bodyMedium, 
                      book.rating == null ? "${book.level}" : "${book.rating}★"
                    ),
                  ]
                ],
              ),
            ),
          ],
        ),
        onPressed: () { 
          // Store the book in the "recently searched" list.
          appState.addBookToRecents(book);
          onBookClicked(book); 
        },
      ),
    );
  }

  void onBookClicked(BookSummary book) async {
    BookDetails results = await _bookDetailsService.getBookDetails(book.id);

    if (mounted) {
      // Change the screen to the "book details" screen.
      pushScreen(context, BookDetailsScreen(
            summaryData: book,
            detailsData: results));
    }
  }
}