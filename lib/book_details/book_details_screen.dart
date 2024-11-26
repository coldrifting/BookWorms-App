import 'package:bookworms_app/book_details/review_widget.dart';
import 'package:bookworms_app/models/BookExtended.dart';
import 'package:bookworms_app/models/BookSummary.dart';
import 'package:flutter/material.dart';

class BookDetailsScreen extends StatefulWidget {
  final BookSummary summaryData;
  final BookExtended extendedData;

  const BookDetailsScreen({
    super.key,
    required this.summaryData,
    required this.extendedData
  });

  @override
  State<BookDetailsScreen> createState() => _BookDetailsScreenState();
}

class _BookDetailsScreenState extends State<BookDetailsScreen> {
  late ScrollController _scrollController;
  late BookSummary bookSummary;
  late BookExtended bookExtended;

  @override
  void initState() {
    super.initState();
    // The initial offset allows for a partial section of the book to be shown
    // on the book details view.
    _scrollController = ScrollController(initialScrollOffset: 250);
    bookSummary = widget.summaryData;
    bookExtended = widget.extendedData;
  }

  /// The entire book details page, containing book image, details, action buttons,
  /// and reviews.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(bookSummary.title),
        backgroundColor: Colors.green[200],
         leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: ListView(
        controller: _scrollController,
        children: [
          // Temporary image for testing purposes.
          Image.network("https://m.media-amazon.com/images/I/71wiGMKadmL._AC_UF1000,1000_QL80_.jpg"),
          _bookDetails(),
          Container(
            color: const Color.fromARGB(255, 239, 239, 239),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const SizedBox(height: 5),
                  _actionButtons(),
                  const SizedBox(height: 15),
                  _reviewList(),
                ],
              ),
            ),
          ),
        ]
      ),
    );
  }

  /// Sub-section containing book information such as title, author, rating,
  /// difficulty, and description.
  Widget _bookDetails() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Text(
            style: const TextStyle(
                fontWeight: FontWeight.bold, 
                fontSize: 28,
             ),
            bookSummary.title
          ),
          Text(
            style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
                fontSize: 18,
            ), 
            bookSummary.authors[0] // Temporarily the first author
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              style: 
              const TextStyle(
                fontSize: 16.0
              ),
              "Level ${bookSummary.difficulty}   |   ${bookSummary.rating}★"
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: RichText(
              textAlign: TextAlign.justify,
              text: TextSpan(
                style: const TextStyle(
                  color: Colors.black, 
                  fontSize: 16.0,
                ), // Regular text
                children: <TextSpan>[
                  const TextSpan(
                    text: 'Description: ',
                    style: TextStyle(fontWeight: FontWeight.bold), // Bold text
                  ),
                  TextSpan(
                    text: bookExtended.description,
                  ),
                ],
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.keyboard_arrow_down_sharp),
            onPressed: () => {},
          ),
        ]
      ),
    );
  }

  /// Buttons for saving a book to a bookshelf, locating a near library, and
  /// rating the book difficulty.
  Widget _actionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ElevatedButton.icon(
          icon: const Icon(Icons.bookmark),
          onPressed: (() => {}),
          label: const Text("Save")),
        ElevatedButton.icon(
          icon: const Icon(Icons.account_balance),
          onPressed: (() => {}),
          label: const Text("Locate")),
        ElevatedButton.icon(
          icon: const Icon(Icons.fitness_center),
          onPressed: (() => {}),
          label: const Text("Rate")),
      ],
    );
  }

  /// Sub-section for the list of review objects.
  Widget _reviewList() {
    // Generate the list of review widgets.
    var reviewCount = bookExtended.reviews.length;
    List<Widget> reviews = List.generate(
      reviewCount,
      (index) => Padding(
        padding: const EdgeInsets.only(bottom: 18.0),
        child: ReviewWidget(review: bookExtended.reviews[index]),
      )
    );

    return Column( // Replace with lazy loading.
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              "Reviews  |  ${bookSummary.rating}",
            ),
            IconButton(
              onPressed: (() => {}), 
              icon: const Icon(Icons.add),
            ),
          ],
        ),
        ...reviews,
      ],
    );
  } 
}