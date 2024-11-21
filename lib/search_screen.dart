import 'dart:async';
import 'package:bookworms_app/Utils.dart';
import 'package:bookworms_app/search_service.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

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
  late SearchService _searchService;
  late FocusNode _focusNode;
  late TextEditingController _textEditingcontroller;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _searchService = SearchService();
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

  /// Callback for when there is a change to the search bar focus
  /// Sets the state of the search
  void _onSearchBarFocusChanged() {
    setState(() {
      _isInActiveSearch = _focusNode.hasFocus;
    });
    // Unregisters the focus listener if the search has become active
    if (_isInActiveSearch) {
      _focusNode.removeListener(_onSearchBarFocusChanged);
    }
  } 

  /// Callback for when the 'Cancel' button is pressed
  /// Unfocuses and clears the search bar; clears the search results
  void _onCancelPressed() {
    setState(() {
      if (_focusNode.hasFocus) {
        _focusNode.unfocus();
      }
      // If the search bar is unfocused, the callback will not be called
      else {
        _isInActiveSearch = false;
      }
      _searchResults.clear();
      _textEditingcontroller.clear();
    });
    // Reregister the search listener
    _focusNode.addListener(_onSearchBarFocusChanged);
  }

  /// Callback for when the search query is changed
  /// Fetches and sets the default results once the debounce timer has expired.
  void _onSearchQueryChanged(String query) async {
    // Maintain the most recent state of the query
    // This state may change during a network call
    _currentQuery = query;
    if (_debounceTimer != null) {
      _debounceTimer!.cancel();
    }
    _debounceTimer = Timer(const Duration(milliseconds: 300), () async {
      // Only fetch results if the query is non-empty
      if (query.isNotEmpty) {
        List<BookSummary> results = await _searchService.getBookSummaries(query, _defaultResultLength);
        // Update the search results if the most recent state of the query is non-empty and the search bar is focused
        if (_currentQuery.isNotEmpty && _focusNode.hasFocus) {
          setState(() {
            _searchResults = results;
          });
          // Scroll to the top of the list
          if (_scrollController.hasClients) {
            _scrollController.animateTo(
              0.0, 
              duration: const Duration(milliseconds: 300), 
              curve: Curves.easeInOut);
          }
        }
      } else {
        setState(() {
          _searchResults = [];
        });
      }
    });
  }

  /// Callback for when the 'Show More' button is pressed
  /// Fetches and appends the expanded results to the default results
  void _onShowMorePressed() async {
    List<BookSummary> results = await _searchService.getBookSummaries(_currentQuery, _expandedResultLength);
    setState(() {
      _searchResults.addAll(results);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          searchBar(),
          Expanded(
            child: !_isInActiveSearch
                ? Center(child: browseScreen())
                : _searchResults.isEmpty
                  ? Center(child: recentsScreen())
                  : resultsScreen()
          ),
        ],
      ),
    );
  }

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

  Widget browseScreen() {
    return const Text("Browse");
  }

  Widget recentsScreen() {
    return const Text("Recent");
  }

  Widget resultsScreen() {
    return ListView.builder(
      controller: _scrollController,
      itemCount: _searchResults.length + 1,
      itemBuilder: (context, index) {
        if (index != _searchResults.length) {
          return Column(
            children: [
              ListTile(
                title: TextButton(
                  child: searchResult(index),
                  onPressed: () {
                    Utils.homeNav.currentState!.pushNamed('/bookdetailspage');
                  },
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

  Widget searchResult(int index) {
    BookSummary searchResult = _searchResults[index];
    // If an image is empty, a sized box is shown.
    Widget bookImage = searchResult.image.isEmpty ? const SizedBox(width: 8.0) : Image.memory(base64Decode(searchResult.image));
    return Row(
      children: [
        bookImage,
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(searchResult.title),
              // Multiple authors may exist. The first is shown.
              Text(searchResult.authors[0]),
            ],
          ),
        ),
      ],
    );
  }
}

