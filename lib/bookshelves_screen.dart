import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:bookworms_app/demo_books.dart'; // Books used for the demo

class BookshelvesScreen extends StatefulWidget {
  const BookshelvesScreen({super.key});

  @override
  State<BookshelvesScreen> createState() => _BookshelvesScreenState();
}

class _BookshelvesScreenState extends State<BookshelvesScreen> { 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Johnny's Bookshelves", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.green[800],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _createBookshelfWidget(),
            const SizedBox(height: 16),
            _bookshelfWidget(
              "Recommended Books",
              [Demo.image1, Demo.image2, Demo.image3],
              [Demo.authors1, Demo.authors2, Demo.authors3],
              Colors.yellow[200],
              Colors.yellow[800]
            ),
            const SizedBox(height: 16),
            _bookshelfWidget(
              "Ms. Wilson's Class Reading List",
              [Demo.image4, Demo.image5, Demo.image6],
              [Demo.authors4, Demo.authors5, Demo.authors6],
              Colors.red[200],
              Colors.red[800]
            ),
            const SizedBox(height: 16),
            _bookshelfWidget(
              "Currently Reading",
              [Demo.image6, Demo.image8, Demo.image9],
              [Demo.authors6, Demo.authors8, Demo.authors9],
              Colors.blue[200],
              Colors.blue[800]
            ),
            const SizedBox(height: 16),
            _bookshelfWidget(
              "Completed Books",
              [Demo.image5, Demo.image10, Demo.image4],
              [Demo.authors5, Demo.authors10, Demo.authors4],
              Colors.green[200],
              Colors.green[800]
            ),
            const SizedBox(height: 16),
            _bookshelfWidget(
              "Animals",
              [Demo.image2, Demo.image5, Demo.image6],
              [Demo.authors2, Demo.authors5, Demo.authors6],
              Colors.grey[200],
              Colors.grey[800]
            ),
            const SizedBox(height: 16),
            _bookshelfWidget(
              "Fairytales",
              [Demo.image8, Demo.image9, Demo.image7],
              [Demo.authors8, Demo.authors9, Demo.authors7],
              Colors.grey[200],
              Colors.grey[800]
            ),
          ],
        ),
      ),
    );
  }

  /// The labeled button for creating a bookshelf.
  Widget _createBookshelfWidget() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        border: Border.all(color: Colors.grey[800] ?? Colors.black),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButton(
            onPressed: () => {}, 
            icon: const Icon(Icons.add)
          ),
          const SizedBox(width: 10),
          const Text(
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            "Create New Bookshelf"
          ),
        ],
      ),
    );
  }

  /// A bookshelf includes the title, book covers, and authors.
  Widget _bookshelfWidget(String name, List<String> images, List<List<String>> authors, Color? mainColor, Color? accentColor) {
    return Container(
      decoration: BoxDecoration(
        color: mainColor,
        border: Border.all(color: accentColor ?? Colors.black),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: _imageLayoutWidget(images),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    name
                  ),
                  Text(
                    style: const TextStyle(fontSize: 14, overflow: TextOverflow.ellipsis),
                    _printFirstAuthors(authors, 2),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// The three book cover images widget. Each image is laid out diagonally
  /// across the container.
  Widget _imageLayoutWidget(List<String> images) {
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
                child: CachedNetworkImage(
                  height: constraints.maxHeight * 0.5,
                  imageUrl: images[0],
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: CachedNetworkImage(
                  height: constraints.maxHeight * 0.5,
                  imageUrl: images[1],
                ),
              ),
              Positioned( // Bottom cover image
                bottom: 5,
                right: 5,
                child: CachedNetworkImage(
                  height: constraints.maxHeight * 0.5,
                  imageUrl: images[2],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // Prints the first 'count' of authors.
  String _printFirstAuthors(List<List<String>> authors, int count) {
    String authorsList = "";
    int authorCount = 0;
    for (var bookAuthors in authors) {
      for (var author in bookAuthors) {
        if (authorCount == count) {
          return "${authorsList}and more";
        }
        authorCount++;
        authorsList += "$author, ";
      }
    }
    return "${authorsList}and more";
  }
}
