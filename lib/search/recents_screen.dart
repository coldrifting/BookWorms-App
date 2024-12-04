import 'package:bookworms_app/demo_books.dart';
import 'package:bookworms_app/models/book_summary.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class RecentsScreen extends StatefulWidget {
  const RecentsScreen({super.key});

  @override
  State<RecentsScreen> createState() => _RecentsScreenState();
}

class _RecentsScreenState extends State<RecentsScreen> { 

  // Temporary for demo.
  final List<BookSummary> _books = [Demo.book1, Demo.book2, Demo.book3, Demo.book4];
  final List<String> _images = [Demo.image1, Demo.image2, Demo.image3, Demo.image4];
  
  @override
  Widget build(BuildContext context) {
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
              labelColor: Colors.green[800],
              unselectedLabelColor: Colors.grey,
              indicatorColor: Colors.green[800],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  Center(child: _recentsWidget()),
                  const Center(child: Text("Advanced Search")),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Recently-viewed books subpage.
  Widget _recentsWidget() {
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
                child: searchResult(index),
                onPressed: () => {},
              ),
            ),
            const Divider(
              color: Colors.grey,
            )
          ],
        );
      }
    );
  }

  /// Individual book search result, including the book image and overview details.
  Widget searchResult(int index) {
    BookSummary searchResult = _books[index];
    CachedNetworkImage bookImage = CachedNetworkImage(imageUrl: _images[index], width: 150);
    return Row(
      children: [
        bookImage,
        const SizedBox(width: 24.0),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16, 
                  fontWeight: FontWeight.bold,
                ),
                searchResult.title
              ),
              Text(
                style: const TextStyle(color: Colors.black54, fontSize: 14),
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