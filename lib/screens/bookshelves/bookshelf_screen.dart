import 'package:bookworms_app/app_state.dart';
import 'package:bookworms_app/models/book/book_details.dart';
import 'package:bookworms_app/models/book/book_summary.dart';
import 'package:bookworms_app/models/book/bookshelf.dart';
import 'package:bookworms_app/resources/colors.dart';
import 'package:bookworms_app/resources/constants.dart';
import 'package:bookworms_app/screens/book_details/book_details_screen.dart';
import 'package:bookworms_app/services/book/book_details_service.dart';
import 'package:bookworms_app/utils/widget_functions.dart';
import 'package:bookworms_app/widgets/change_child_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

/// The [BookshelfScreen] contains a list of books of the bookshelf.
class BookshelfScreen extends StatefulWidget {
  final Bookshelf bookshelf;

  const BookshelfScreen({
    super.key,
    required this.bookshelf,
  });

  @override
  State<BookshelfScreen> createState() => _BookshelfScreenState();
}

/// The state of [BookshelfScreen].
class _BookshelfScreenState extends State<BookshelfScreen> {
  late Bookshelf bookshelf;
  late BookDetailsService _bookDetailsService;
  late MenuController _menuController;

  @override
  void initState() {
    super.initState();
    bookshelf = widget.bookshelf;
    _bookDetailsService = BookDetailsService();
    _menuController = MenuController();
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    AppState appState = Provider.of<AppState>(context);
    List<BookSummary> books = bookshelf.books;

    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: defaultOverlay(),
        title: Text(
          "${appState.isParent ? "${appState.children[appState.selectedChildID].name}'s" : "My"} Bookshelves", 
          style: TextStyle(
            color: colorWhite, 
            overflow: TextOverflow.ellipsis
          )
        ),
        backgroundColor: colorGreen,
        leading: IconButton(
          color: colorWhite,
          icon: const Icon(Icons.arrow_back),
          onPressed: () { Navigator.of(context).pop(); },
        ),
        actions: [
          appState.isParent ? ChangeChildWidget(
            onChildChanged: () { Navigator.of(context).pop(); },
          ) : SizedBox.shrink()
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: ListView.builder(
          itemCount: books.length + 1,
          itemBuilder: (context, index) {
            if (index == 0) {
              return Column(
                children: [
                  addVerticalSpace(16),
                  Row(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(bookshelf.name, style: textTheme.titleMedium, overflow: TextOverflow.ellipsis),
                      ),
                      Spacer(),
                      if (bookshelf.type == BookshelfType.custom || !appState.isParent)
                        _dropDownMenu(textTheme),
                    ],
                  ),
                ],
              );
            } else {
              return Column(
                children: [
                  addVerticalSpace(16),
                  InkWell(
                    onTap: () { onBookClicked(books[index - 1]); },
                    child: _bookshelfWidget(textTheme, books[index - 1])
                  ),
                ],
              );
            }
          }
        ),
      ),
    );
  }

  Widget _dropDownMenu(TextTheme textTheme) {
    return MenuAnchor(
      controller: _menuController,
      builder: (BuildContext context, MenuController controller, Widget? child) {
        return IconButton(
          icon: const Icon(Icons.more_horiz),
          onPressed: () {
            if (controller.isOpen) {
              controller.close();
            } else {
              controller.open();
            }
          },
        );
      },
      menuChildren: [
        MenuItemButton(
          onPressed: () {
            _menuController.close();
            // Confirm that the user wants to delete the bookshelf.
            _showDeleteConfirmationDialog(textTheme);
          },
          child: Row(
            children: [
              Icon(Icons.delete_forever, color: colorRed, size: 20),
              addHorizontalSpace(8),
              Text(
                'Delete Bookshelf',
                style: textTheme.bodyMedium?.copyWith(
                  color: colorRed,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        MenuItemButton(
          onPressed: () {
            _menuController.close();
            _showEditBookshelfNameDialog(textTheme);
          },
          child: Row(
            children: [
              Icon(Icons.edit, color: colorGreyDark, size: 20),
              addHorizontalSpace(8),
              Text(
                'Rename Bookshelf',
                style: textTheme.bodyMedium?.copyWith(
                  color: colorGreyDark,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        )
      ],
      style: MenuStyle(
        backgroundColor: WidgetStateProperty.all(Colors.white),
        shape: WidgetStateProperty.all(RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        )),
      ),
    );
  }

  Future<void> _showEditBookshelfNameDialog(TextTheme textTheme) {
    TextEditingController controller = TextEditingController();

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Center(child: Text('Rename Bookshelf')),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: controller,
                decoration: InputDecoration(
                  hintText: "Enter a new bookshelf name",
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel', style: TextStyle(color: colorGreyDark!)),
            ),
            TextButton(
              onPressed: () async {
                if (controller.text.trim().isNotEmpty) {
                  Navigator.of(context).pop();
                  Provider.of<AppState>(context, listen: false).renameClassroomBookshelf(bookshelf.name, controller.text.trim());
                }
              },
              style: TextButton.styleFrom(
                backgroundColor: colorGreen,
                foregroundColor: colorWhite
              ),
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  Future<dynamic> _showDeleteConfirmationDialog(TextTheme textTheme) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Center(child: Text('Delete Bookshelf')),
          content: const Text(
            textAlign: TextAlign.center,
            'Are you sure you want to permanently delete this bookshelf?'
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _deleteBookshelf();
              },
              child: Text('Delete', style: TextStyle(color: colorRed)),
            ),
          ],
        );
      },
    );
  }

  /// Deleting a bookshelf navigates to the bookshelf screen and removes the bookshelf.
  void _deleteBookshelf() {
    AppState appState = Provider.of<AppState>(context, listen: false);
    Navigator.of(context).pop();
    if (appState.isParent) {
      appState.deleteChildBookshelf(appState.selectedChildID, bookshelf);
    } else {
      appState.deleteClassroomBookshelf(bookshelf);
    }
  }

  // When clicking a book widget, navigates to the [BookDetailsScreen].
  void onBookClicked(BookSummary book) async {
    BookDetails results = await _bookDetailsService.getBookDetails(book.id);
    if (mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BookDetailsScreen(summaryData: book, detailsData: results)
        )
      );
    }
  }

  // Displays the book summary data and includes a slider functionality to delete books.
  Widget _bookshelfWidget(TextTheme textTheme, BookSummary book) {
    AppState appState = Provider.of<AppState>(context);
    return Slidable(
      key: UniqueKey(),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        dismissible: DismissiblePane(
          onDismissed: () { 
            appState.removeBookFromBookshelf(appState.selectedChildID, bookshelf, book.id);
            setState(() {
              bookshelf.books.removeWhere((b) => b.id == book.id);
            });
          },
        ),
        children: [
          SlidableAction(
            onPressed: (BuildContext context) { 
              if (appState.isParent) {
                appState.removeBookFromBookshelf(appState.selectedChildID, bookshelf, book.id);
              } else {
                appState.removeBookFromClassroomBookshelf(bookshelf, book);
              }
              setState(() {
                bookshelf.books.removeWhere((b) => b.id == book.id);
              });
            },
            backgroundColor: colorRed!,
            foregroundColor: colorWhite,
            borderRadius: BorderRadius.circular(4),
            icon: Icons.delete,
            label: 'Delete',
          ),
        ],
      ),
      child: Container(
        decoration: BoxDecoration(
          color: colorGreyLight,
          border: Border.all(color: Colors.grey[200]!),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: 150,
                child: CachedNetworkImage(
                  imageUrl: book.imageUrl!,
                  placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => Image.asset("assets/images/book_cover_unavailable.jpg"),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      book.title
                    ),
                    Text(
                      style: const TextStyle(fontSize: 14, overflow: TextOverflow.ellipsis),
                      printFirstAuthors(book.authors, 2),
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
            ),
          ],
        ),
      ),
    );
  }
}