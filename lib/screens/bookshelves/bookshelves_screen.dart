import 'package:bookworms_app/resources/constants.dart';
import 'package:bookworms_app/resources/theme.dart';
import 'package:bookworms_app/screens/bookshelves/bookshelf_screen.dart';
import 'package:bookworms_app/widgets/bookshelf_image_layout_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:bookworms_app/app_state.dart';
import 'package:bookworms_app/models/book/bookshelf.dart';
import 'package:bookworms_app/resources/colors.dart';
import 'package:bookworms_app/utils/widget_functions.dart';
import 'package:bookworms_app/widgets/change_child_widget.dart';

/// The [BookshelvesScreen] contains a user's curated/personal bookshelves. The
/// user is able to add a new bookshelf here, or access their current bookshelves.
class BookshelvesScreen extends StatefulWidget {
  const BookshelvesScreen({super.key});

  @override
  State<BookshelvesScreen> createState() => _BookshelvesScreenState();
}

/// The state of [BookshelvesScreen].
class _BookshelvesScreenState extends State<BookshelvesScreen> {
  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    AppState appState = Provider.of<AppState>(context);
    List<Bookshelf> bookshelves = appState.bookshelves;

    return Scaffold(
      appBar: AppBar(
          title: Text(
              "${appState.children[appState.selectedChildID].name}'s Bookshelves",
              style: const TextStyle(color: colorWhite)),
          backgroundColor: colorGreen,
          actions: const [ChangeChildWidget()]),
      floatingActionButton: FloatingActionButton.extended(
          foregroundColor: colorWhite,
          backgroundColor: colorGreen,
          icon: const Icon(Icons.add),
          label: Text("Add Bookshelf"),
          onPressed: () {
            _createBookshelf(textTheme);
          }),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: ListView.builder(
            itemCount: bookshelves.length,
            itemBuilder: (context, index) {
              double bottomPadding = index == bookshelves.length - 1 ? 16 : 0;
              return Column(
                children: [
                  addVerticalSpace(16),
                  InkWell(
                      onTap: () {
                        onBookClicked(index);
                      },
                      child: _bookshelfWidget(textTheme, index)),
                  addVerticalSpace(bottomPadding)
                ],
              );
            }),
      ),
    );
  }

  // Upon clicking a book, open the [BookshelfScreen].
  void onBookClicked(int bookshelfIndex) async {
    AppState appState = Provider.of<AppState>(context, listen: false);
    Bookshelf bookshelf = await appState.getChildBookshelf(
        appState.selectedChildID, bookshelfIndex);

    if (mounted) {
      pushScreen(context, BookshelfScreen(bookshelf: bookshelf));
    }
  }

  // Dialog for creating a new bookshelf.
  void _createBookshelf(TextTheme textTheme) {
    AppState appState = Provider.of<AppState>(context, listen: false);
    showDialog(
      context: context,
      builder: (context) {
        TextEditingController controller = TextEditingController();
        return AlertDialog(
          title: Text('Create New Bookshelf'),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(
              labelText: 'Bookshelf Name',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              style: TextButton.styleFrom(foregroundColor: colorGreyDark),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                String name = controller.text.trim();
                if (name.isNotEmpty) {
                  Navigator.pop(context, name);
                  appState.addChildBookshelf(
                      appState.selectedChildID,
                      Bookshelf(
                          type: BookshelfType.custom, name: name, books: []));
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: colorGreen,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              child: Text('Create', style: textTheme.titleSmallWhite),
            ),
          ],
        );
      },
    );
  }

  // Dialog to delete a bookshelf. Appears when sliding the Slider or clicking "Delete".
  Future<void> _deleteBookshelf(TextTheme textTheme, Bookshelf bookshelf) {
    AppState appState = Provider.of<AppState>(context, listen: false);

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Center(child: Text('Delete Bookshelf')),
          content: Text(
              'Are you sure you want to permanently delete the bookshelf titled "${bookshelf.name}?"'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                appState.deleteChildBookshelf(
                    appState.selectedChildID, bookshelf);
                Navigator.of(context).pop();
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  /// A bookshelf includes the title, book cover(s), and author(s).
  Widget _bookshelfWidget(TextTheme textTheme, int bookshelfIndex) {
    AppState appState = Provider.of<AppState>(context);
    Bookshelf bookshelf = appState.bookshelves[bookshelfIndex];

    return bookshelf.type == BookshelfType.custom
        ? Slidable(
            key: UniqueKey(),
            endActionPane: ActionPane(
              motion: const ScrollMotion(),
              dismissible: DismissiblePane(
                onDismissed: () {
                  appState.deleteChildBookshelf(
                      appState.selectedChildID, bookshelf);
                },
              ),
              children: [
                SlidableAction(
                  onPressed: (BuildContext context) {
                    _deleteBookshelf(textTheme, bookshelf);
                  },
                  backgroundColor: colorRed!,
                  foregroundColor: colorWhite,
                  borderRadius: BorderRadius.circular(4),
                  icon: Icons.delete,
                  label: 'Delete',
                ),
              ],
            ),
            child: _bookshelfContent(textTheme, bookshelf))
        : _bookshelfContent(textTheme, bookshelf, isLocked: true);
  }
}

/// The content of the bookshelf (images, title, authors, rating, level).
Widget _bookshelfContent(TextTheme textTheme, Bookshelf bookshelf,
    {bool isLocked = false}) {
  var authors = bookshelf.books.expand((book) => book.authors);

  return Container(
    decoration: BoxDecoration(
      color: bookshelf.type.color[200],
      border: Border.all(color: bookshelf.type.color[700]!),
      borderRadius: BorderRadius.circular(4),
    ),
    child: Stack(children: [
      Positioned(
          top: 10,
          right: 10,
          child: Text(
              bookshelf.type.name == "InProgress"
                  ? "In Progress"
                  : bookshelf.type.name,
              style: TextStyle(color: bookshelf.type.color[700]!))),
      Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
                width: 100,
                height: 100,
                child: BookshelfImageLayoutWidget(bookshelf: bookshelf)),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(bookshelf.name, style: textTheme.titleSmall),
                  Text(printFirstAuthors(authors, 2),
                      style: const TextStyle(
                          fontSize: 14, overflow: TextOverflow.ellipsis)),
                ],
              ),
            ),
          ),
        ],
      ),
    ]),
  );
}
