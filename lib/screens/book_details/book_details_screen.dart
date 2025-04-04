import 'package:bookworms_app/app_state.dart';
import 'package:bookworms_app/models/Result.dart';
import 'package:bookworms_app/models/book/bookshelf.dart';
import 'package:bookworms_app/models/book/user_review.dart';
import 'package:bookworms_app/resources/constants.dart';
import 'package:bookworms_app/services/book/book_details_service.dart';
import 'package:bookworms_app/services/book/book_difficulty_service.dart';
import 'package:bookworms_app/services/book/book_summary_service.dart';
import 'package:bookworms_app/widgets/app_bar_custom.dart';
import 'package:bookworms_app/widgets/bookshelf_image_layout_widget.dart';
import 'package:bookworms_app/widgets/reading_level_info_widget.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:bookworms_app/screens/book_details/create_review_widget.dart';
import 'package:bookworms_app/screens/book_details/review_widget.dart';
import 'package:bookworms_app/models/book/book_details.dart';
import 'package:bookworms_app/models/book/book_summary.dart';
import 'package:bookworms_app/resources/colors.dart';
import 'package:bookworms_app/utils/widget_functions.dart';
import 'package:provider/provider.dart';

/// The [BookDetailsScreen] contains detailed information regarding a
/// specific book. It also displays relevant user reviews and actions to
/// "save", "review", and "rate" the book.
class BookDetailsScreen extends StatefulWidget {
  final BookSummary summaryData; // Overview book data
  final BookDetails detailsData; // More specific book data

  const BookDetailsScreen(
      {super.key, required this.summaryData, required this.detailsData});

  @override
  State<BookDetailsScreen> createState() => _BookDetailsScreenState();
}

/// The state of the [BookDetailsScreen].
class _BookDetailsScreenState extends State<BookDetailsScreen> {
  late ScrollController _scrollController; // Sets initial screen offset.
  final GlobalKey _parentKey = GlobalKey();
  final GlobalKey _imageKey = GlobalKey();

  late BookSummary bookSummary;
  late BookDetails bookDetails;
  late CachedNetworkImage image;

  var _isExpanded =
      false; // Denotes if the description/book information is expanded.

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _setScrollOffset();
    });
    bookSummary = widget.summaryData;
    bookDetails = widget.detailsData;
    image = CachedNetworkImage(
      imageUrl: bookSummary.imageUrl!,
      placeholder: (context, url) => Center(child: CircularProgressIndicator()),
      errorWidget: (context, url, error) =>
          Image.asset("assets/images/book_cover_unavailable.jpg"),
    );
  }

  // Set the offset of the scroll controller.
  void _setScrollOffset() {
    final RenderBox? imageRenderBox =
        _imageKey.currentContext?.findRenderObject() as RenderBox?;
    final RenderBox? parentRenderBox =
        _parentKey.currentContext?.findRenderObject() as RenderBox?;

    if (imageRenderBox != null &&
        parentRenderBox != null &&
        imageRenderBox.hasSize &&
        parentRenderBox.hasSize) {
      double imageWidth = imageRenderBox.size.width;
      double imageHeight = imageRenderBox.size.height;

      double aspectRatio = imageWidth / imageHeight;
      double newImageWidth = parentRenderBox.size.width;
      double newImageHeight = newImageWidth / aspectRatio;

      // Calculate the new scroll offset
      double offset = newImageHeight - 200;
      _scrollController.jumpTo(offset > 0 ? offset : newImageHeight);
    }
  }

  /// The entire book details page, containing book image, details, action buttons,
  /// and reviews.
  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    // A reference to a Nav state is needed since modal popups are not
    // technically contained within the proper nested navigation context
    NavigatorState navState = Navigator.of(context);

    return Scaffold(
      key: _parentKey,
      // Book details app bar
      appBar: AppBarCustom(bookSummary.title),
      // Book details content
      body: ListView(controller: _scrollController, children: [
        SizedBox(
          width: double.infinity,
          child: FittedBox(
            fit: BoxFit.cover,
            child: CachedNetworkImage(
              key: _imageKey,
              imageUrl: bookSummary.imageUrl!,
              placeholder: (context, url) =>
                  Center(child: CircularProgressIndicator()),
              errorWidget: (context, url, error) =>
                  Image.asset("assets/images/book_cover_unavailable.jpg"),
            ),
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
                _actionButtons(textTheme, bookSummary, navState),
                addVerticalSpace(15),
                _reviewList(textTheme),
              ],
            ),
          ),
        ),
      ]),
    );
  }

  /// Sub-section containing book information such as title, author, rating,
  /// difficulty, and description.
  Widget _bookDetails(TextTheme textTheme) {
    var difficulty = bookSummary.level ?? "N/A";
    var rating =
        bookSummary.rating == null ? "Unrated" : "${bookSummary.rating}★";

    // Toggles the expansion of the description/book information.
    void toggleExpansion() {
      setState(() {
        _isExpanded = !_isExpanded;
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
            style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
                fontSize: 18),
            textAlign: TextAlign.center,
            bookSummary.authors.isNotEmpty
                ? bookSummary.authors.map((author) => author).join('\n')
                : "Unknown Author(s)",
          ),
          // Book difficulty and rating
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  style: textTheme.bodyLarge,
                  "Level $difficulty",
                ),
                RawMaterialButton(
                  onPressed: () => pushScreen(context, const ReadingLevelInfoWidget()),
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(4.0),
                  constraints: BoxConstraints(
                    maxWidth: 40,
                  ),
                  child: const Icon(
                    Icons.help_outline,
                    color: colorBlack,
                    size: 20
                  )
                ),
                Container(
                  height: 40,
                  width: 1,
                  color: Colors.black,
                ),
                addHorizontalSpace(16),
                Text(
                  style: textTheme.bodyLarge,
                  rating,
                )
              ],
            ),
          ),
          // Book description (including extra book details)
          _description(textTheme),
          // "Expand" icon
          IconButton(
            icon: Icon(_isExpanded
                ? Icons.keyboard_arrow_up_sharp
                : Icons.keyboard_arrow_down_sharp),
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
            maxLines: _isExpanded ? null : 5,
            overflow:
                _isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
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
          if (_isExpanded) ..._expandedDetails(textTheme)
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
      if (bookDetails.pageCount != null)
        _detailText("Pages", "${bookDetails.pageCount}", textTheme),
      if (bookDetails.isbn10 != null)
        _detailText("ISBN-10", bookDetails.isbn10!, textTheme),
      if (bookDetails.isbn13 != null)
        _detailText("ISBN-13", bookDetails.isbn13!, textTheme),
      _detailText("Published", bookDetails.publishYear.toString(), textTheme),
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
  Widget _actionButtons(
      TextTheme textTheme, BookSummary book, NavigatorState navState) {
    AppState appState = Provider.of<AppState>(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton.icon(
          icon: const Icon(Icons.bookmark),
          onPressed: (() => {_saveToBookshelfModal(textTheme, book, navState)}),
          label: const Text("Save"),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
          ),
        ),
        ElevatedButton.icon(
          icon: const Icon(Icons.edit_note_sharp),
          onPressed: _addReview,
          label: const Text("Review"),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
          ),
        ),
        if (appState.isParent) ...[
          ElevatedButton.icon(
            icon: const Icon(Icons.fitness_center),
            onPressed: (() => {_rateBookDifficultyDialog(textTheme)}),
            label: const Text("Rate"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
            ),
          ),
        ]
      ],
    );
  }

  void _saveToBookshelfModal(
      TextTheme textTheme, BookSummary book, NavigatorState navState) {
    AppState appState = Provider.of<AppState>(context, listen: false);
    List<Bookshelf> bookshelves = appState.bookshelves
        .where((shelf) => shelf.type != BookshelfType.classroom)
        .toList();

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Save to Bookshelf", style: textTheme.headlineSmall)
                ],
              ),
              addVerticalSpace(8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          minimumSize: Size(200, 38),
                          textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          iconSize: 26,
                          foregroundColor: colorWhite,
                          backgroundColor: colorGreen),
                      onPressed: () async {
                        String? newBookshelfName = await showTextEntryDialog(
                            context,
                            "Create New Bookshelf",
                            "New Bookshelf Name",
                            confirmText: "Add");
                        if (newBookshelfName != null) {
                          var bookshelf = Bookshelf(
                              type: appState.isParent
                                  ? BookshelfType.custom
                                  : BookshelfType.classroom,
                              name: newBookshelfName,
                              books: [book]);
                          Result result = appState.isParent
                              ? await appState.addChildBookshelfWithBook(
                              appState.selectedChildID, bookshelf)
                              : await appState
                              .createClassroomBookshelfWithBook(bookshelf);

                          if (context.mounted) {
                            resultAlert(context, result);
                          }
                        }
                      },
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Icon(Icons.add),
                            addHorizontalSpace(8),
                            Text("Save to New Bookshelf")
                          ]))
                ],
              ),
              addVerticalSpace(10),
              Expanded(
                  child: ListView.builder(
                itemCount: bookshelves.length,
                itemBuilder: (context, index) {
                  Bookshelf bookshelf = bookshelves[index];
                  return Column(
                    children: [
                      InkWell(
                        child: Container(
                          decoration: BoxDecoration(
                            color: bookshelf.type.color[200],
                            border:
                                Border.all(color: bookshelf.type.color[700]!),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Row(
                            children: [
                              SizedBox(
                                child: SizedBox(
                                    height: 75,
                                    width: 75,
                                    child: BookshelfImageLayoutWidget(
                                        bookshelf: bookshelf)),
                              ),
                              addHorizontalSpace(16),
                              Text(bookshelf.name,
                                  style: textTheme.titleSmall,
                                  overflow: TextOverflow.ellipsis),
                            ],
                          ),
                        ),
                        onTap: () async {
                          Result result;
                          if (appState.isParent) {
                            result = await appState.addBookToBookshelf(
                                appState.selectedChildID,
                                bookshelf,
                                bookSummary);
                          } else {
                            result = await appState.addBookToClassroomBookshelf(bookshelf, bookSummary);
                          }

                          if (context.mounted) {
                            resultAlert(context, result);
                          }
                        },
                      ),
                      addVerticalSpace(10),
                    ],
                  );
                },
              )),
            ],
          ),
        );
      },
    );
  }

  void _rateBookDifficultyDialog(TextTheme textTheme) {
    AppState appState = Provider.of<AppState>(context, listen: false);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(
            child: Text(
              'Rate Book Difficulty',
              style: textTheme.titleLarge,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "How difficult was this book for ${appState.children[appState.selectedChildID].name}?",
                textAlign: TextAlign.center,
              ),
              addVerticalSpace(16),
              _difficultyButton('Very Easy', 1, textTheme),
              _difficultyButton('Easy', 2, textTheme),
              _difficultyButton('Just Right', 3, textTheme),
              _difficultyButton('Hard', 4, textTheme),
              _difficultyButton('Very Hard', 5, textTheme),
            ],
          ),
        );
      },
    );
  }

  Widget _difficultyButton(String text, int index, TextTheme textTheme) {
    AppState appState = Provider.of<AppState>(context, listen: false);
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton(
          onPressed: () {
            BookDifficultyService bookDifficultyService =
                BookDifficultyService();
            bookDifficultyService.sendDifficulty(bookSummary.id,
                appState.children[appState.selectedChildID].id, index);
            Navigator.of(context, rootNavigator: true).pop();
          },
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.zero,
            ),
          ),
          child: Text(text, style: textTheme.bodyLarge),
        ),
      ),
    );
  }

  /// The list of review widgets corresponding to the given book.
  Widget _reviewList(TextTheme textTheme) {
    var rating =
        bookSummary.rating == null ? "Unrated" : "${bookSummary.rating}★";
    // Generate the list of review widgets.
    var reviewCount = bookDetails.reviews.length;
    List<Widget> reviews = List.generate(
        reviewCount,
        (index) => Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: ReviewWidget(review: bookDetails.reviews[index]),
            ));

    return Column(
      // Replace with lazy loading.
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              style: textTheme.titleMedium,
              "Reviews  |  $rating",
            )
          ],
        ),
        addVerticalSpace(8),
        ...reviews,
      ],
    );
  }

  void _addReview() {
    pushScreen(
        context,
        CreateReviewWidget(
            bookId: bookSummary.id, updateReviews: _updateReviews));
  }

  Future<void> _updateReviews() async {
    BookSummaryService bookSummaryService = BookSummaryService();
    double? updatedbookRating =
        (await bookSummaryService.getBookSummary(bookSummary.id)).rating;
    BookDetailsService bookDetailsService = BookDetailsService();
    List<UserReview> updatedBookReviews =
        (await bookDetailsService.getBookDetails(bookSummary.id)).reviews;
    setState(() {
      bookSummary.rating = updatedbookRating;
      bookDetails.reviews = updatedBookReviews;
    });
  }
}
