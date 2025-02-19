import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:bookworms_app/app_state.dart';
import 'package:bookworms_app/resources/colors.dart';
import 'package:bookworms_app/widgets/book_summary_widget.dart';

/// The [RecentsScreen] displays a scrollable list of recently searched books.
class RecentsScreen extends StatefulWidget {
  const RecentsScreen({super.key});

  @override
  State<RecentsScreen> createState() => _RecentsScreenState();
}

/// The state of the [RecentsScreen].
class _RecentsScreenState extends State<RecentsScreen> { 
  @override
  Widget build(BuildContext context) {
    AppState appState = Provider.of<AppState>(context);
    var books = appState.recentlySearchedBooks;

    return ListView.builder(
      itemCount: books.length,
      itemBuilder: (context, index) {
        return Column(
          children: [
            BookSummaryWidget(
              book: books[books.length - index - 1], 
            ),
            const Divider(
              color: colorGrey,
            )
          ],
        );
      }
    );
  }
}