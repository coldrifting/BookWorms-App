import 'package:bookworms_app/app_state.dart';
import 'package:bookworms_app/models/Result.dart';
import 'package:bookworms_app/models/book/bookshelf.dart';
import 'package:bookworms_app/models/classroom/classroom.dart';
import 'package:bookworms_app/resources/colors.dart';
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
    return FractionallySizedBox(
      widthFactor: 0.45,
      child: TextButton(
        onPressed: () => _addClassBookshelfAlert(textTheme),
        style: TextButton.styleFrom(
          backgroundColor: colorGreen,
          foregroundColor: colorWhite,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Add New Bookshelf"),
            addHorizontalSpace(8),
            Icon(Icons.bookmark, color: colorWhite),
          ],
        ),
      ),
    );
  }

  // Dialog for creating a new bookshelf.
  void _addClassBookshelfAlert(TextTheme textTheme) {
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
              onPressed: () async {
                String name = controller.text.trim();
                if (name.isNotEmpty) {
                  Result result = await appState.createClassroomBookshelf(Bookshelf(type: BookshelfType.classroom, name: name, books: []));
                  resultAlert(context, result);
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
}