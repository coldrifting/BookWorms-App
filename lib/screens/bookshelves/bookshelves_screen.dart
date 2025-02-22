import 'package:bookworms_app/resources/constants.dart';
import 'package:bookworms_app/resources/theme.dart';
import 'package:bookworms_app/screens/bookshelves/bookshelf_screen.dart';
import 'package:bookworms_app/widgets/bookshelf_image_layout_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:bookworms_app/app_state.dart';
import 'package:bookworms_app/models/book/bookshelf.dart';
import 'package:bookworms_app/models/child/child.dart';
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
    Child selectedChild = appState.children[appState.selectedChildID];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "${selectedChild.name}'s Bookshelves",
          style: const TextStyle(color: colorWhite)
        ),
        backgroundColor: colorGreen,
        actions: const [ChangeChildWidget()], // TO DO: Update bookshelves to reflect current child.
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: ListView.builder(
          itemCount: selectedChild.bookshelves.length + 1,
          itemBuilder: (context, index) {
            if (index == 0) {
              return Column(
                children: [
                  addVerticalSpace(16),
                  _createBookshelfWidget(textTheme)
                ],
              );
            } else {
              return Column(
                children: [
                  addVerticalSpace(16),
                  InkWell(
                    onTap: () { onBookClicked(index - 1); },
                    child: _bookshelfWidget(textTheme, index - 1)
                  ),
                ],
              );
            }
          }
        ),
      ),
    );
  }

  // Upon clicking a book, open the [BookshelfScreen].
  void onBookClicked(int bookshelfIndex) async {
    AppState appState = Provider.of<AppState>(context, listen: false);
    Bookshelf fullBookshelf = await appState.getChildBookshelf(appState.selectedChildID, bookshelfIndex);
    if(mounted) {
      pushScreen(context, BookshelfScreen(bookshelf: fullBookshelf));
    }
  }

  /// The labeled button for creating a bookshelf.
  Widget _createBookshelfWidget(TextTheme textTheme) {
    return Material(
      color: colorGreyLight,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: () { _createBookshelf(textTheme); },
        splashColor: colorGreyDark!.withValues(alpha: 0.1),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: colorGreyDark ?? Colors.black, width: 1),
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.add, size: 20),
              addHorizontalSpace(8),
              Text("Create New Bookshelf", style: textTheme.titleMedium!),
            ],
          ),
        ),
      ),
    );
  }

  // Dialog for creating a new bookshelf.
  void _createBookshelf(TextTheme textTheme) {
    AppState appState = Provider.of<AppState>(context, listen: false);
    int selectedChildId = appState.selectedChildID;

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
                    selectedChildId, 
                    Bookshelf(type: BookshelfType.completed, name: name, books: [])
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: colorGreen,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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
          content: Text('Are you sure you want to permanently delete the bookshelf titled "${bookshelf.name}?"'),
          actions: [
            TextButton(
              onPressed: () { Navigator.of(context).pop(); },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                appState.deleteChildBookshelf(appState.selectedChildID, bookshelf);
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
    Bookshelf bookshelf = appState.children[appState.selectedChildID].bookshelves[bookshelfIndex];

    // Up to the first three authors for display purposes.
    var authors = bookshelf.books.expand((book) => book.authors);

    return Slidable(
      key: UniqueKey(),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        dismissible: DismissiblePane(
          onDismissed: () { appState.deleteChildBookshelf(appState.selectedChildID, bookshelf); },
        ),
        children: [
          SlidableAction(
            onPressed: (BuildContext context) { _deleteBookshelf(textTheme, bookshelf); },
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
          color: bookshelf.type.color[200],
          border: Border.all(color: bookshelf.type.color[700]!),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: BookshelfImageLayoutWidget(bookshelf: bookshelf),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      bookshelf.name
                    ),
                    Text(
                      style: const TextStyle(fontSize: 14, overflow: TextOverflow.ellipsis),
                      printFirstAuthors(authors, 2),
                    ),
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
