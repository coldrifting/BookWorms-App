import 'package:bookworms_app/models/book/book_summary.dart';
import 'package:bookworms_app/resources/theme.dart';
import 'package:bookworms_app/screens/search/no_results_screen.dart';
import 'package:bookworms_app/widgets/app_bar_custom.dart';
import 'package:bookworms_app/widgets/book_summary_widget.dart';
import 'package:flutter/material.dart';


/// The [AdvancedSearchResultsScreen] contains a list of advanced search results. 
class AdvancedSearchResultsScreen extends StatefulWidget {
  final List<BookSummary> bookSummaries;

  const AdvancedSearchResultsScreen({
    super.key,
    required this.bookSummaries
  });

  @override
  State<AdvancedSearchResultsScreen> createState() => _AdvancedSearchResultsScreenState();
}


/// The state of the [AdvancedSearchResultsScreen].
class _AdvancedSearchResultsScreenState extends State<AdvancedSearchResultsScreen> {
  late List<BookSummary> bookSummaries;

  @override
  void initState() {
    super.initState();
    bookSummaries = widget.bookSummaries;
  }

  /// The advanced search results screen contains a list of advanced search results.
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
              Divider(color: context.colors.grey)
            ],
          );
        }
      );
    } else {
      mainContent = NoResultsScreen();
    }

    return Scaffold(
      appBar: AppBarCustom("Advanced Search"),
      body: mainContent 
    );
  } 
}