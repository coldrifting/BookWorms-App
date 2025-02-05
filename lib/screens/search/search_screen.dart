import 'dart:async';
import 'package:bookworms_app/screens/search/browse_screen.dart';
import 'package:bookworms_app/screens/search/recents_and_advanced_search.dart';
import 'package:bookworms_app/models/book_summary.dart';
import 'package:bookworms_app/services/book_images_service.dart';
import 'package:bookworms_app/services/book_summaries_service.dart';
import 'package:bookworms_app/theme/colors.dart';
import 'package:bookworms_app/utils/widget_functions.dart';
import 'package:bookworms_app/widgets/book_summary_widget.dart';
import 'package:flutter/material.dart';

/// The [SearchScreen] displays a search bar and a scrollable list of 
/// relevant books related to the query typed in by the user.
class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

/// The state of the [SearchScreen].
class _SearchScreenState extends State<SearchScreen> {
  static const _defaultResultLength = 10;
  static const _expandedResultLength = 50;

  var _isInActiveSearch = false;
  var _currentQuery = "";
  var _searchResults = [];
  Timer? _debounceTimer;

  late BookSummariesService _bookSummariesService;
  late BookImagesService _bookImagesService;
  
  late FocusNode _focusNode;
  late TextEditingController _textEditingcontroller;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _bookSummariesService = BookSummariesService();
    _bookImagesService = BookImagesService();
    _focusNode = FocusNode();
    _focusNode.addListener(_onSearchBarFocusChanged);
    _textEditingcontroller = TextEditingController();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _textEditingcontroller.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  /// Callback for when there is a change to the search bar focus.
  /// Sets the state of the search.
  void _onSearchBarFocusChanged() {
    setState(() {
      _isInActiveSearch = _focusNode.hasFocus;
    });

    // Unregisters the focus listener if the search has become active.
    if (_isInActiveSearch) {
      _focusNode.removeListener(_onSearchBarFocusChanged);
    }
  } 

  /// Callback for when the 'Cancel' button is pressed.
  /// Unfocuses and clears the search bar; clears the search results.
  void _onCancelPressed() {
    setState(() {
      if (_focusNode.hasFocus) {
        _focusNode.unfocus();
      }
      // If the search bar is unfocused, the callback will not be called.
      else {
        _isInActiveSearch = false;
      }

      _currentQuery = "";
      _searchResults.clear();
      _textEditingcontroller.clear();
    });

    // Reregister the search listener.
    _focusNode.addListener(_onSearchBarFocusChanged);
  }

  /// Fetches the search results and the corresponding images.
  Future<List<BookSummary>> getResults(String query, int resultLength) async {
    List<BookSummary> results = await _bookSummariesService.getBookSummaries(query, _defaultResultLength);
    List<String> bookIds = results.map((bookSummary) => bookSummary.id).toList();
    List<Image> bookImages = await _bookImagesService.getBookImages(bookIds);
    for (int i = 0; i < results.length; i++) {
      results[i].setImage(bookImages[i]);
    }
    return results;
  }

  /// Callback for when the search query is changed.
  /// Fetches and sets the default results once the debounce timer has expired.
  void _onSearchQueryChanged(String query) async {
    // Maintain the most recent state of the query.
    // This state may change during a network call.
    _currentQuery = query;
    if (_debounceTimer != null) {
      _debounceTimer!.cancel();
    }

    _debounceTimer = Timer(const Duration(milliseconds: 300), () async {
      // Only fetch results if the query is non-empty.
      if (query.isNotEmpty) {
        List<BookSummary> results = await getResults(query, _defaultResultLength);

        // Update the search results if the most recent state of the query is non-empty and the search bar is focused.
        if (_currentQuery.isNotEmpty && _focusNode.hasFocus) {
          setState(() {
            _searchResults = results;
          });

          // Scroll to the top of the list.
          if (_scrollController.hasClients) {
            _scrollController.animateTo(
              0.0, 
              duration: const Duration(milliseconds: 300), 
              curve: Curves.easeInOut
            );
          }
        }
      } else {
        setState(() {
          _searchResults = [];
        });
      }
    });
  }

  /// Callback for when the 'Show More' button is pressed.
  /// Fetches and appends the expanded results to the default results.
  void _onShowMorePressed() async {
    List<BookSummary> results = await getResults(_currentQuery, _expandedResultLength);
    setState(() {
      _searchResults.addAll(results);
    });
  }

 /// The search screen consists of a search bar and a sub-widget (either browse, recents, or results).
  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    // The sub-widget is determined by the current search status.
    Widget mainContent;
    if (!_isInActiveSearch) {
      mainContent = const BrowseScreen();
    } else if (_currentQuery.isEmpty) {
      mainContent = const RecentsAdvancedSearchScreen();
    } else if (_searchResults.isNotEmpty) {
      mainContent = _resultsScreen(textTheme);
    } else {
      mainContent = Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(
              Icons.search_off,
              size: 50.0,
              color: colorGrey,
            ),
            addVerticalSpace(8),
            const Text(
              "No Results",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: colorGrey,
              ),
            ),
          ],
        ),
      );
    }
  
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            children: [
              addVerticalSpace(8),
              searchBar(),
              addVerticalSpace(8),
              Expanded(
                child: mainContent
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Search queries are entered in the search bar widget.
  Widget searchBar() {
    return Row(
      children: [
        Expanded(
            child: SearchBar(
              leading: const Icon(Icons.search),
              hintText: "Find a book",
              focusNode: _focusNode,
              controller: _textEditingcontroller,
              onChanged: _onSearchQueryChanged,
              shape: WidgetStateProperty.all(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              )),
              shadowColor: const WidgetStatePropertyAll(Colors.transparent),
            ),
          ),
        if (_isInActiveSearch)
          Row(
            children: [
              addVerticalSpace(8),
              TextButton(
                onPressed: _onCancelPressed,
                style: TextButton.styleFrom(
                  foregroundColor: colorBlack,
                ),
                child: const Text("Cancel"),
              ),
            ],
          ),
      ],
    );
  }

  /// Sub-widget containing the search results corresponding to the most recently processed search query.
  Widget _resultsScreen(TextTheme textTheme) {
    return ListView.builder(
      controller: _scrollController,
      itemCount: _searchResults.length + 1,
      itemBuilder: (context, index) {
        if (index != _searchResults.length) {
          return Column(
            children: [
              BookSummaryWidget(book: _searchResults[index]),
              const Divider(
                color: colorGrey,
              )
            ],
          );
        } else if (_searchResults.length == _defaultResultLength) {
          return Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: _onShowMorePressed, 
                  style: TextButton.styleFrom(
                    foregroundColor: colorGreyDark,
                  ),
                  child: const Text("Show More"),
                ),
              ),
            ],
          );
        }
        return null;
      }
    );
  }
}
