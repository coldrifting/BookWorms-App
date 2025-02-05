import 'package:bookworms_app/app_state.dart';
import 'package:bookworms_app/models/book_details.dart';
import 'package:bookworms_app/models/book_summary.dart';
import 'package:bookworms_app/screens/book_details/book_details_screen.dart';
import 'package:bookworms_app/services/book_details_service.dart';
import 'package:bookworms_app/utils/widget_functions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BookPreviewListWidget extends StatefulWidget {
  final List<dynamic> books;
  final int index;

  const BookPreviewListWidget({
    super.key,
    required this.books,
    required this.index
  });

  @override
  State<BookPreviewListWidget> createState() => _BookPreviewListWidgetState();
}

class _BookPreviewListWidgetState extends State<BookPreviewListWidget> {
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
    
    BookSummary book = widget.books[widget.index];
    Image bookImage = book.image!;

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
              child: bookImage,
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
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BookDetailsScreen(
            summaryData: book,
            detailsData: results,
          )
        )
      );
    }
  }
}