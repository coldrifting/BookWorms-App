import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:bookworms_app/models/book_summary.dart';
import 'package:bookworms_app/resources/colors.dart';

/// The [BookshelfWidget] displays an overview of a user's bookshelf. It
/// includes a short display of book covers, the bookshelf title, and some
/// authors present in the bookshelf.
class BookshelfWidget extends StatelessWidget {
  final String name;
  final List<String> images;
  final List<BookSummary> books;

  const BookshelfWidget({
    super.key, 
    required this.name,
    required this.images,
    required this.books,
  });

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Container(
      height: 335,
      // Bookshelf shadow
      decoration: BoxDecoration(
        color: colorWhite,
        boxShadow: [
          BoxShadow(
            color: colorBlack.withValues(alpha: 0.2),
            spreadRadius: 1,
            blurRadius: 6,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16.0),
              // Bookshelf name
              child: Text(
                style: textTheme.titleLarge,
                name,
              ),
            ),
            // List of bookshelf books
            Expanded(
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _bookPreview(image: images[0], book: books[0], textTheme: textTheme),
                  const VerticalDivider(),
                  _bookPreview(image: images[1], book: books[1], textTheme: textTheme),
                  const VerticalDivider(),
                  _bookPreview(image: images[2], book: books[2], textTheme: textTheme),
                  const VerticalDivider(),
                  _bookPreview(image: images[3], book: books[3], textTheme: textTheme),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Displays book summary information with the book cover, title, author, 
  /// rating, and difficulty.
  Widget _bookPreview({required String image, required BookSummary book, required TextTheme textTheme}) {
    var difficulty = book.difficulty.isEmpty ? "N/A" : book.difficulty;
    var rating = book.rating == 0 ? "Unrated" : "${book.rating}★";

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            // Cover image
            child: CachedNetworkImage(
              height: 175,
              imageUrl: image,
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
                    fontSize: 18, 
                    fontWeight: FontWeight.bold, 
                    overflow: TextOverflow.ellipsis, 
                    height: 1.2,
                  ),
                  maxLines: 2,
                  book.title,
                ),
                // Book author
                Text(
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16, overflow: TextOverflow.ellipsis), 
                  maxLines: 1,
                  book.authors.isNotEmpty 
                  ? book.authors.map((author) => author).join(', ')
                  : "Unknown Author(s)",
                ),
                // Book rating and difficulty
                Text(
                  textAlign: TextAlign.center,
                  style: textTheme.bodyMedium, 
                  "$rating  |  $difficulty"
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}