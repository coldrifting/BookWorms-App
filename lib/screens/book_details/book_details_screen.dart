import 'package:bookworms_app/screens/book_details/create_review_widget.dart';
import 'package:bookworms_app/screens/book_details/review_widget.dart';
import 'package:bookworms_app/models/book_details.dart';
import 'package:bookworms_app/models/book_summary.dart';
import 'package:bookworms_app/theme/colors.dart';
import 'package:bookworms_app/utils/widget_functions.dart';
import 'package:flutter/material.dart';

/// The [BookDetailsScreen] contains detailed information regarding a
/// specific book. It also displays relevant user reviews and actions to
/// "save", "locate", and "rate" the book.
class BookDetailsScreen extends StatefulWidget {
  final BookSummary summaryData;  // Overview book data
  final BookDetails detailsData;  // More specific book data

  const BookDetailsScreen({
    super.key,
    required this.summaryData,
    required this.detailsData
  });

  @override
  State<BookDetailsScreen> createState() => _BookDetailsScreenState();
}

/// The state of the [BookDetailsScreen].
class _BookDetailsScreenState extends State<BookDetailsScreen> {
  late ScrollController _scrollController; // Sets initial screen offset.
  late BookSummary bookSummary;
  late BookDetails bookDetails;

  var isExpanded = false; // Denotes if the description/book information is expanded.
  var maxLength = 500; // Max length of the shortened description.

  @override
  void initState() {
    super.initState();
    // The initial offset allows for a partial section of the book to be shown
    // on the book details view.
    _scrollController = ScrollController(initialScrollOffset: 250);
    bookSummary = widget.summaryData;
    bookDetails = widget.detailsData;
  }

  /// The entire book details page, containing book image, details, action buttons,
  /// and reviews.
  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Scaffold(
      // Book details app bar
      appBar: AppBar(
        title: Text(
          bookSummary.title, 
          style: const TextStyle(
            fontWeight: FontWeight.normal,
            color: colorWhite, 
            overflow: TextOverflow.ellipsis
          )
        ),
        backgroundColor: colorGreen,
        leading: IconButton(
          color: colorWhite,
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      // Book details content
      body: ListView(
        controller: _scrollController,
        children: [
          // Temporary hardcode for demo.
          bookSummary.title == "The Giving Tree" 
          ? Image.network("https://m.media-amazon.com/images/I/71wiGMKadmL._AC_UF1000,1000_QL80_.jpg") 
          : SizedBox(
            width: double.infinity,
            child: FittedBox(
              fit: BoxFit.cover, 
              child: bookSummary.image,
            ),
          ),
          _bookDetails(textTheme),
          Container(
            color: const Color.fromARGB(255, 239, 239, 239),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  addVerticalSpace(5),
                  _actionButtons(),
                  addVerticalSpace(15),
                  _reviewList(textTheme),
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
  Widget _bookDetails(TextTheme textTheme) {
    var difficulty = bookSummary.difficulty.isEmpty ? "N/A" : bookSummary.difficulty;
    var rating = bookSummary.rating == 0 ? "Unrated" : "${bookSummary.rating}★";

    // Toggles the expansion of the description/book information.
    void toggleExpansion() {
      setState(() {
        isExpanded = !isExpanded;
      });
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Book title
          Text(
            style: textTheme.headlineSmall,
            textAlign: TextAlign.center,
            bookSummary.title,
          ),
          // Book author(s)
          Text(
            style: const TextStyle(fontWeight: FontWeight.bold, fontStyle: FontStyle.italic, fontSize: 18), 
            textAlign: TextAlign.center,
            bookSummary.authors.isNotEmpty 
            ? bookSummary.authors.map((author) => author).join('\n')
            : "Unknown Author(s)",
          ),
          // Book difficulty and rating
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              style: textTheme.bodyLarge,
              "Level $difficulty   |   $rating"
            ),
          ),
          // Book description (including extra book details)
          _description(textTheme),
          // "Expand" icon
          IconButton(
            icon: Icon(
              isExpanded 
              ? Icons.keyboard_arrow_up_sharp 
              : Icons.keyboard_arrow_down_sharp
            ),
            onPressed: toggleExpansion,
          ),
        ],
      ),
    );
  }

  /// Contains the written description and additional book details including the ISBN(s)
  /// publisher information, and number of pages.
  Widget _description(TextTheme textTheme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            // If not expanded, 5 lines are shown at most with ellipsis present.
            maxLines: isExpanded ? null : 5,
            overflow: isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
            text: TextSpan(
              style: textTheme.bodyLarge,
              children: <TextSpan>[
                if (bookDetails.description.isNotEmpty) ...[
                  TextSpan(
                    text: 'Description: ',
                    style: textTheme.titleSmall,
                  ),
                  TextSpan(text: bookDetails.description),
                ] else 
                  const TextSpan(text: 'No description available.'),
              ],
            ),
          ),
          if (isExpanded) ..._expandedDetails(textTheme)
        ],
      ),
    );
  }

  /// Additional book details displayed upon expanded.
  List<Widget> _expandedDetails(TextTheme textTheme) {
    return [
      addVerticalSpace(16),
      const Divider(height: 1),
      addVerticalSpace(16),

    // Empty details are not included.
    if (bookDetails.pageCount > 0)
      _detailText("Pages", "${bookDetails.pageCount}", textTheme),
    if (bookDetails.isbn10.isNotEmpty)
      _detailText("ISBN-10", bookDetails.isbn10, textTheme),
    if (bookDetails.isbn13.isNotEmpty)
      _detailText("ISBN-13", bookDetails.isbn13, textTheme),
    if (bookDetails.publisher.isNotEmpty)
      _detailText("Publisher", bookDetails.publisher, textTheme),
    if (bookDetails.publishDate.isNotEmpty)
      _detailText("Published", bookDetails.publishDate, textTheme),
  ];
}

  /// Creates book detail text given the label and the text value.
  Widget _detailText(String label, String value, TextTheme textTheme) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Text(
        "$label: $value",
        style: textTheme.bodyLarge,
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

  /// The list of review widgets corresponding to the given book.
  Widget _reviewList(TextTheme textTheme) {
    // Generate the list of review widgets.
    var reviewCount = bookDetails.reviews.length;
    List<Widget> reviews = List.generate(
      reviewCount,
      (index) => Padding(
        padding: const EdgeInsets.only(bottom: 18.0),
        child: ReviewWidget(review: bookDetails.reviews[index]),
      )
    );

    return Column( // Replace with lazy loading.
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              style: textTheme.titleMedium,
              "Reviews  |  ${bookSummary.rating}★",
            ),
            IconButton(
              onPressed: (addReview), 
              icon: const Icon(Icons.add),
            ),
          ],
        ),
        ...reviews,
      ],
    );
  }

  void addReview() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreateReviewWidget(bookId: bookSummary.id)
      )
    );
  }
}