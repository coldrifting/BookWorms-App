import 'package:bookworms_app/app_state.dart';
import 'package:bookworms_app/models/book/bookshelf.dart';
import 'package:bookworms_app/resources/colors.dart';
import 'package:bookworms_app/resources/constants.dart';
import 'package:bookworms_app/screens/bookshelves/bookshelf_screen.dart';
import 'package:bookworms_app/showcase/showcase_controller.dart';
import 'package:bookworms_app/showcase/showcase_widgets.dart';
import 'package:bookworms_app/utils/widget_functions.dart';
import 'package:bookworms_app/widgets/announcements_widget.dart';
import 'package:bookworms_app/widgets/app_bar_custom.dart';
import 'package:bookworms_app/widgets/bookshelf_image_layout_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

/// The [BookshelvesScreen] contains a user's curated/personal bookshelves. The
/// user is able to add a new bookshelf here, or access their current bookshelves.
class BookshelvesScreen extends StatefulWidget {
  const BookshelvesScreen({super.key});

  @override
  State<BookshelvesScreen> createState() => _BookshelvesScreenState();
}

/// The state of [BookshelvesScreen].
class _BookshelvesScreenState extends State<BookshelvesScreen> {
  late final showcaseController = ShowcaseController();
  late final List<GlobalKey> navKeys = showcaseController.getKeysForScreen('bookshelves');

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    AppState appState = Provider.of<AppState>(context);
    List<Bookshelf> bookshelves = appState.bookshelves;

    String headerTitle = "${appState.isParent
        ? "${appState.children[appState.selectedChildID].name}'s"
        : "My"} Bookshelves";

    return Scaffold(
      appBar: AppBarCustom(headerTitle, isLeafPage: false,isChildSwitcherEnabled: true, rightAction: AnnouncementsWidget()),
      floatingActionButton: BWShowcase(
        showcaseKey: navKeys[1],
        description: "You can even add your own custom bookshelves!",
        targetPadding: EdgeInsets.all(6),
        tooltipBorderRadius: BorderRadius.circular(16),
        child: floatingActionButtonWithText("Add Bookshelf", Icons.add, () async {
          String? newBookshelfName = await showTextEntryDialog(context, "Create New Bookshelf", "Bookshelf Name");
          if (newBookshelfName != null) {
            appState.addChildBookshelf(appState.selectedChildID,
                Bookshelf(type: BookshelfType.custom, name: newBookshelfName, books: []));
          }
        }),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: ListView.builder(
            itemCount: bookshelves.length,
            itemBuilder: (context, index) {
              double bottomPadding = index == bookshelves.length - 1 ? 16 : 0;
              return Column(
                children: [
                  addVerticalSpace(16),
                  index == 1
                    ? BWShowcase(
                        showcaseKey: navKeys[0],
                        title: "This is a Bookshelf",
                        description:
                          "Bookshelves are your way to make custom book lists. "
                          "You get \"Completed\" and \"In Progress\" automatically. "
                          "Bookshelves from your child's classroom(s) will also appear on this screen.",
                        tooltipBorderRadius: BorderRadius.circular(6),
                        child: InkWell(
                          onTap: () {
                            onBookClicked(index);
                          },
                          child: _bookshelfWidget(textTheme, index)),
                    )
                    : InkWell(
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

  // Dialog to delete a bookshelf. Appears when sliding the Slider or clicking "Delete".
  Future<void> _deleteBookshelf(Bookshelf bookshelf) async {
    AppState appState = Provider.of<AppState>(context, listen: false);

    bool? shouldDelete = await showConfirmDialog(context,
        "Delete Bookshelf",
        'Are you sure you want to permanently delete the bookshelf titled "${bookshelf.name}?"',
        confirmColor: colorRed);
    if (shouldDelete == true) {
      appState.deleteChildBookshelf(appState.selectedChildID, bookshelf);
    }
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
              children: [
                SlidableAction(
                  onPressed: (BuildContext context) {
                    _deleteBookshelf(bookshelf);
                  },
                  backgroundColor: colorRed,
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
              bookshelf.type.name == "InProgress" || bookshelf.type.name == "Completed"
                  ? ""
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
