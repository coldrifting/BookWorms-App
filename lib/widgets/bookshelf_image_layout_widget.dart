import 'package:bookworms_app/models/bookshelf.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class BookshelfImageLayoutWidget extends StatelessWidget {
  final Bookshelf bookshelf;

  const BookshelfImageLayoutWidget({
    super.key,
    required this.bookshelf
  });

  /// Displays at most 3 of the book covers in the bookshelf. Each image is
  /// laid out diagonally across the container.
  @override
  Widget build(BuildContext context) {
    var bookCovers = bookshelf.books.take(3).map((book) => book.imageUrl).where((imageUrl) => imageUrl != null).toList();
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
                if (bookCovers.length > 1)
                  Positioned( // Top cover image
                      top: 5,
                      left: 5,
                      child: SizedBox(
                        height: constraints.maxHeight * 0.5,
                        child: CachedNetworkImage(
                          imageUrl: bookCovers[1]!,
                          placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                          errorWidget: (context, url, error) => Image.asset("assets/images/book_cover_unavailable.jpg"),
                        ),
                      ),
                    ),
                Align(
                  alignment: Alignment.center,
                  child: SizedBox(
                    height: constraints.maxHeight * 0.5,
                    child: CachedNetworkImage(
                      imageUrl: bookCovers[0]!,
                      placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) => Image.asset("assets/images/book_cover_unavailable.jpg"),
                    ),
                  ),
                ),
                if (bookCovers.length > 2)
                  Positioned( // Bottom cover image
                    bottom: 5,
                    right: 5,
                    child: SizedBox(
                      height: constraints.maxHeight * 0.5,
                      child: CachedNetworkImage(
                        imageUrl: bookCovers[2]!,
                        placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                        errorWidget: (context, url, error) => Image.asset("assets/images/book_cover_unavailable.jpg"),
                      ),
                    ),
                  ),
              ],
            );
          }
        },
      ),
    );
  }
}