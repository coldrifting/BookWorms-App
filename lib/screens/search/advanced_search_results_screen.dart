import 'package:bookworms_app/models/book/book_summary.dart';
import 'package:bookworms_app/resources/colors.dart';
import 'package:bookworms_app/screens/search/no_results_screen.dart';
import 'package:bookworms_app/utils/widget_functions.dart';
import 'package:bookworms_app/widgets/book_summary_widget.dart';
import 'package:flutter/material.dart';

class AdvancedSearchResultsScreen extends StatefulWidget {
  final List<BookSummary> bookSummaries;

  const AdvancedSearchResultsScreen({
    super.key,
    required this.bookSummaries
  });

  @override
  State<AdvancedSearchResultsScreen> createState() => _AdvancedSearchResultsScreenState();
}

class _AdvancedSearchResultsScreenState extends State<AdvancedSearchResultsScreen> {
  late List<BookSummary> bookSummaries;

  @override
  void initState() {
    super.initState();
    bookSummaries = widget.bookSummaries;
  }

  @override
  Widget build(BuildContext context) {
    Widget mainContent;
    if (bookSummaries.isNotEmpty) {
      mainContent = ListView.builder(
        itemCount: bookSummaries.length,
        itemBuilder: (context, index) {
          return Column(
            children: [
              BookSummaryWidget(book: bookSummaries[index]),
              const Divider(color: colorGrey)
            ],
          );
        }
      );
    } else {
      mainContent = NoResultsScreen();
    }

    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: defaultOverlay(),
        title: Text(
          "Advanced Search",
          style: const TextStyle(
            fontWeight: FontWeight.normal,
            color: colorWhite,
            overflow: TextOverflow.ellipsis
          )
        ),
        backgroundColor: colorGreen,
        leading: IconButton(
          color: colorWhite,
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: mainContent 
    );
  } 
}