import 'package:bookworms_app/resources/theme.dart';
import 'package:bookworms_app/screens/bookshelves/bookshelf_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:bookworms_app/app_state.dart';
import 'package:bookworms_app/models/bookshelf.dart';
import 'package:bookworms_app/models/child.dart';
import 'package:bookworms_app/resources/colors.dart';
import 'package:bookworms_app/utils/widget_functions.dart';
import 'package:bookworms_app/widgets/change_child_widget.dart';
import 'package:flutter_svg/svg.dart';

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

    if (selectedChild.bookshelves.isEmpty) {
      appState.setChildBookshelves(appState.selectedChildID);
    }
    List<Bookshelf> bookshelves = selectedChild.bookshelves;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "${selectedChild.name}'s Bookshelves",
          style: const TextStyle(
            color: colorWhite
          )
        ),
        backgroundColor: colorGreen,
        actions: const [ChangeChildWidget()],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: ListView.builder(
          itemCount: bookshelves.length + 1,
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
                    onTap: () { onBookClicked(bookshelves[index - 1]); },
                    child: _bookshelfWidget(textTheme, bookshelves[index - 1])
                  ),
                ],
              );
            }
          }
        ),
      ),
    );
  }

  void onBookClicked(Bookshelf bookshelf) async {
    AppState appState = Provider.of<AppState>(context, listen: false);
    Bookshelf fullBookshelf = await appState.getChildBookshelf(appState.selectedChildID, bookshelf);
    if(mounted) {
      pushScreen(
        context, 
        BookshelfScreen(bookshelf: fullBookshelf)
      );
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
              Text(
                "Create New Bookshelf",
                style: textTheme.titleMedium!,
              ),
            ],
          ),
        ),
      ),
    );
  }

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
              style: TextButton.styleFrom(
                foregroundColor: colorGreyDark,
              ),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                String name = controller.text.trim();
                if (name.isNotEmpty) {
                  Navigator.pop(context, name);
                  appState.addChildBookshelf(selectedChildId, Bookshelf(name: name, books: []));
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: colorGreen,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Create', 
                style: textTheme.titleSmallWhite
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteBookshelf(TextTheme textTheme, Bookshelf bookshelf) {
    AppState appState = Provider.of<AppState>(context, listen: false);

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Center(child: Text('Delete Bookshelf')),
          content: Text(
              'Are you sure you want to permanently delete the bookshelf titled $bookshelf.name?'),
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
                appState.deleteChildBookshelf(appState.selectedChildID, bookshelf);
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  /// A bookshelf includes the title, book cover(s), and author(s).
  Widget _bookshelfWidget(TextTheme textTheme, Bookshelf bookshelf) {
    AppState appState = Provider.of<AppState>(context);
    Color mainColor = Colors.grey[200]!; // Temporary
    Color accentColor = Colors.grey[800]!; // Temporary

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
      child: Container(
        decoration: BoxDecoration(
          color: mainColor,
          border: Border.all(color: accentColor),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: _imageLayoutWidget(bookshelf),
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

  /// Displays some of the book cover(s) in the bookshelf. Each image is
  /// laid out diagonally across the container.
  Widget _imageLayoutWidget(Bookshelf bookshelf) {
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
