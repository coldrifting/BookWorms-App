import 'package:bookworms_app/app_state.dart';
import 'package:bookworms_app/models/Result.dart';
import 'package:bookworms_app/models/book/book_details.dart';
import 'package:bookworms_app/models/book/book_summary.dart';
import 'package:bookworms_app/models/book/bookshelf.dart';
import 'package:bookworms_app/resources/colors.dart';
import 'package:bookworms_app/resources/constants.dart';
import 'package:bookworms_app/screens/book_details/book_details_screen.dart';
import 'package:bookworms_app/services/book/book_details_service.dart';
import 'package:bookworms_app/utils/widget_functions.dart';
import 'package:bookworms_app/widgets/app_bar_custom.dart';
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
      appBar: AppBarCustom("Bookshelf Details", isChildSwitcherEnabled: true),
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
                      if (bookshelf.type != BookshelfType.recommended || bookshelf.type == BookshelfType.custom
                          || (!appState.isParent && bookshelf.type == BookshelfType.classroom))
                        _dropDownMenu(textTheme, appState),
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
                  if (index == books.length)
                    addVerticalSpace(16)
                ],
              );
            }
          }
        ),
      ),
    );
  }

  Widget _dropDownMenu(TextTheme textTheme, AppState appState) {
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

  void _showEditBookshelfNameDialog(TextTheme textTheme) async {
    String? newBookshelfName = await showTextEntryDialog(
        context,
        "Rename Bookshelf",
        "Enter a new bookshelf name",
        confirmText: "Rename");

    if (newBookshelfName != null) {
      _renameBookshelf(newBookshelfName);
    }
  }

  void _showDeleteConfirmationDialog(TextTheme textTheme) async {
    bool? shouldDeleteBookshelf = await showConfirmDialog(
        context,
        "Delete Bookshelf",
        "Are you sure you want to permanently delete this bookshelf?",
        confirmText: "Delete",
        confirmColor: colorRed);

    if (shouldDeleteBookshelf) {
      _deleteBookshelf();
    }
  }

  void _renameBookshelf(String newName) async {
    AppState appState = Provider.of<AppState>(context, listen: false);
    Result result;
    if (appState.isParent) {
      result = await appState.renameChildBookshelf(appState.selectedChildID, bookshelf, newName);

      setState(() {
        bookshelf.name = newName;
      });
      // Not sure why this hack is needed to keep things in sync, but it seems to work
      // Currently books seem to sync between tabs for classroom shelves,
      // but they don't stay in sync for children bookshelves.
      // Future.delayed(const Duration(milliseconds: 100), () {
      //   if (mounted) {
      //     setState(() {
      //       bookshelf.name = newName;
      //     });
      //   }
      // });
    } else {
      result = await appState.renameClassroomBookshelf(bookshelf.name, newName);
    }

    if (mounted) {
      resultAlert(context, result);
    }
  }

  /// Deleting a bookshelf navigates to the bookshelf screen and removes the bookshelf.
  void _deleteBookshelf() async {
    AppState appState = Provider.of<AppState>(context, listen: false);
    Result result;
    if (appState.isParent) {
      result = await appState.deleteChildBookshelf(appState.selectedChildID, bookshelf);
    } else {
      result = await appState.deleteClassroomBookshelf(bookshelf);
    }

    if (mounted) {
      resultAlert(context, result);
    }
  }

  // When clicking a book widget, navigates to the [BookDetailsScreen].
  void onBookClicked(BookSummary book) async {
    BookDetails results = await _bookDetailsService.getBookDetails(book.id);
    if (mounted) {
      pushScreen(context, BookDetailsScreen(summaryData: book, detailsData: results));
    }
  }

  // Displays the book summary data and includes a slider functionality to delete books.
  Widget _bookshelfWidget(TextTheme textTheme, BookSummary book) {
    AppState appState = Provider.of<AppState>(context);
    var isSlidable = bookshelf.type != BookshelfType.recommended || bookshelf.type == BookshelfType.custom
      || (!appState.isParent && bookshelf.type == BookshelfType.classroom);

    if (!isSlidable) {
      return _bookContent(textTheme, book);
    }

    return Slidable(
      key: UniqueKey(),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        dismissible: DismissiblePane(
          onDismissed: () async {
            Result result; 
            if (appState.isParent) {
              result = await appState.removeBookFromBookshelf(appState.selectedChildID, bookshelf, book.id);
            } else {
              result = await appState.removeBookFromClassroomBookshelf(bookshelf, book);
            }
            setState(() {
              bookshelf.books.removeWhere((b) => b.id == book.id);
            });
            resultAlert(context, result);
          },
        ),
        children: [
          SlidableAction(
            onPressed: (BuildContext context) async { 
              Result result;
              if (appState.isParent) {
                result = await appState.removeBookFromBookshelf(appState.selectedChildID, bookshelf, book.id);
              } else {
                result = await appState.removeBookFromClassroomBookshelf(bookshelf, book);
              }
              setState(() {
                bookshelf.books.removeWhere((b) => b.id == book.id);
              });
              resultAlert(context, result);
            },
            backgroundColor: colorRed,
            foregroundColor: colorWhite,
            borderRadius: BorderRadius.circular(4),
            icon: Icons.delete,
            label: 'Delete',
          ),
        ],
      ),
      child: _bookContent(textTheme, book)
    );
  }

  Widget _bookContent(TextTheme textTheme, BookSummary book) {
    AppState appState = Provider.of<AppState>(context);
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Container(
      decoration: BoxDecoration(
        color: colorGreenLight,
        border: Border.all(color: colorGreen),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withAlpha(50),
            blurRadius: 8,
            spreadRadius: 2,
            offset: Offset(2, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: SizedBox(
                    width: 150,
                    child: CachedNetworkImage(
                      imageUrl: book.imageUrl!,
                      placeholder: (context, url) =>
                          Center(child: CircularProgressIndicator(color: colorGreen)),
                      errorWidget: (context, url, error) =>
                          Image.asset("assets/images/book_cover_unavailable.jpg"),
                    ),
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
                        book.title,
                        style: textTheme.titleSmall,
                      ),
                      Text(
                        printFirstAuthors(book.authors, 2),
                        style: const TextStyle(
                          fontSize: 14,
                          overflow: TextOverflow.ellipsis,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      if (book.rating != null && book.level != null) ...[
                        Text(
                          "${book.rating}★ • ${book.level}",
                          textAlign: TextAlign.center,
                          style: textTheme.bodyMedium
                        ),
                      ]
                      else if (book.rating != null || book.level != null) ...[
                        Text(
                          book.rating == null ? "${book.level}" : "${book.rating}★",
                          textAlign: TextAlign.center,
                          style: textTheme.bodyMedium
                        ),
                      ]
                    ],
                  ),
                ),
              ),
            ],
          ),
          if (bookshelf.type == BookshelfType.custom || (!appState.isParent && bookshelf.type == BookshelfType.classroom))
            Positioned(
              top: 8,
              right: 8,
              child: IconButton(
                icon: Icon(Icons.delete_forever),
                iconSize: 24,
                onPressed: () async {
                  Result result;
                  if (appState.isParent) {
                    result = await appState.removeBookFromBookshelf(appState.selectedChildID, bookshelf, book.id);
                  } else {
                    result = await appState.removeBookFromClassroomBookshelf(bookshelf, book);
                  }
                  setState(() {
                    bookshelf.books.removeWhere((b) => b.id == book.id);
                  });
                  resultAlert(context, result, false);
                },
              ),
            ),
        ],
      ),
    );
  }
}