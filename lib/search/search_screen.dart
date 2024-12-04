import 'dart:async';
import 'package:bookworms_app/book_details/book_details_screen.dart';
import 'package:bookworms_app/search/browse_screen.dart';
import 'package:bookworms_app/search/recents_screen.dart';
import 'package:bookworms_app/services/book_details_service.dart';
import 'package:bookworms_app/models/book_details.dart';
import 'package:bookworms_app/models/book_summary.dart';
import 'package:bookworms_app/services/book_images_service.dart';
import 'package:bookworms_app/services/book_summaries_service.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  static const _defaultResultLength = 10;
  static const _expandedResultLength = 50;

  var _isInActiveSearch = false;
  var _currentQuery = "";
  var _searchResults = [];
  Timer? _debounceTimer;

  late BookSummariesService _bookSummariesService;
  late BookDetailsService _bookDetailsService;
  late BookImagesService _bookImagesService;
  
  late FocusNode _focusNode;
  late TextEditingController _textEditingcontroller;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _bookSummariesService = BookSummariesService();
    _bookDetailsService = BookDetailsService();
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
    // The sub-widget is determined by the current search status.
    Widget mainContent;
    if (!_isInActiveSearch) {
      mainContent = const BrowseScreen();
    } else if (_searchResults.isEmpty) {
      mainContent = const RecentsScreen();
    } else {
      mainContent = _resultsScreen();
    }
  
     return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          const SizedBox(height: 26),
          searchBar(),
          const SizedBox(height: 8),
          Expanded(
            child: mainContent
          ),
        ],
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
              const SizedBox(width: 8.0),
              TextButton(
                onPressed: _onCancelPressed,
                style: TextButton.styleFrom(
                  foregroundColor: Colors.black,
                ),
                child: const Text("Cancel"),
              ),
            ],
          ),
      ],
    );
  }

  /// Callback for when a search result is selected.
  /// Fetches the book's details and navigates to the book's details page.
  void _onBookClicked(int index) async {
    BookDetails results = await _bookDetailsService.getBookDetails(_searchResults[index].id);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BookDetailsScreen(
          summaryData: _searchResults[index],
          detailsData: results,
        )
      )
    );
  }

  /// Sub-widget containing the search results corresponding to the most recently processed search query.
  Widget _resultsScreen() {
    return ListView.builder(
      controller: _scrollController,
      itemCount: _searchResults.length + 1,
      itemBuilder: (context, index) {
        if (index != _searchResults.length) {
          return Column(
            children: [
              ListTile(
                title: TextButton(
                  style: TextButton.styleFrom(
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero
                    ),
                  ),
                  child: searchResult(index),
                  onPressed: () { _onBookClicked(index); },
                ),
              ),
              const Divider(
                color: Colors.grey,
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
                      foregroundColor: Colors.grey[700],
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

  /// The results corresponding to a search query are displayed in a search result widget.
  Widget searchResult(int index) {
    BookSummary searchResult = _searchResults[index];
    Image bookImage = searchResult.image!;
    return Row(
      children: [
        bookImage,
        const SizedBox(width: 24.0),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16, 
                  fontWeight: FontWeight.bold,
                ),
                searchResult.title
              ),
              Text(
                style: const TextStyle(color: Colors.black54, fontSize: 14),
                overflow: TextOverflow.ellipsis,
                searchResult.authors.isNotEmpty 
                ? searchResult.authors.map((author) => author).join(', ')
                : "Unknown Author(s)",
              ),
            ],
          ),
        ),
      ],
    );
  }
}
