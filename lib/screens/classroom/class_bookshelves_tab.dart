import 'package:bookworms_app/app_state.dart';
import 'package:bookworms_app/models/action_result.dart';
import 'package:bookworms_app/models/book/bookshelf.dart';
import 'package:bookworms_app/models/classroom/classroom.dart';
import 'package:bookworms_app/resources/constants.dart';
import 'package:bookworms_app/resources/theme.dart';
import 'package:bookworms_app/utils/widget_functions.dart';
import 'package:bookworms_app/widgets/bookshelf_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ClassBookshelves extends StatefulWidget {
  const ClassBookshelves({super.key});

  @override
  State<ClassBookshelves> createState() => _ClassBookshelvesState();
}

class _ClassBookshelvesState extends State<ClassBookshelves> {
  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    AppState appState = Provider.of<AppState>(context);
    Classroom classroom = appState.classroom!;
    
    return SingleChildScrollView(
      child: Column(
        children: [
          addVerticalSpace(8),
          _addClassBookshelfButton(textTheme),
          
          for (Bookshelf bookshelf in classroom.bookshelves) ...[
            addVerticalSpace(16),
            BookshelfWidget(bookshelf: bookshelf),
          ],
        ],
      ),
    );
  }

  Widget _addClassBookshelfButton(TextTheme textTheme) {
    return SizedBox(
      width: 200,
      child: TextButton(
        onPressed: () => _addClassBookshelfAlert(),
        style: smallButtonStyle,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Add New Bookshelf"),
            addHorizontalSpace(8),
            Icon(Icons.bookmark),
          ],
        ),
      ),
    );
  }

  // Dialog for creating a new bookshelf.
  Future<void> _addClassBookshelfAlert() async {
    AppState appState = Provider.of<AppState>(context, listen: false);
    String? newBookshelfName = await showTextEntryDialog(
        context,
        'Create New Bookshelf',
        'Bookshelf Name',
        confirmText: 'Create');

    if (newBookshelfName == null) {
      return;
    }

    Result result = await appState.createClassroomBookshelf(Bookshelf(type: BookshelfType.classroom, name: newBookshelfName, books: []));
    resultAlert(context, result, false);
  }
}