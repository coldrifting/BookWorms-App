import 'package:bookworms_app/app_state.dart';
import 'package:bookworms_app/models/book/bookshelf.dart';
import 'package:bookworms_app/models/classroom/classroom.dart';
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
    AppState appState = Provider.of<AppState>(context);
    Classroom classroom = appState.classroom!;
    
    return Column(
      children: [
        for (Bookshelf bookshelf in classroom.bookshelves) ...[
          addVerticalSpace(16),
          BookshelfWidget(bookshelf: bookshelf),
        ],
      ],
    );
  }
}