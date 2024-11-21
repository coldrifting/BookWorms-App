import 'dart:async';
import 'package:bookworms_app/Utils.dart';
import 'package:flutter/material.dart';
import 'dart:math';

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
  late FocusNode _focusNode;
  late TextEditingController _textEditingcontroller;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
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

  /// Simulates a network call for testing purposes
  Future<List<String>> getResults(String query, bool expanded) async {
    await Future.delayed(const Duration(milliseconds: 200));
    Random rand = Random();
    var count = expanded ? _expandedResultLength : _defaultResultLength;
    List<String> results = List.generate(count, (index) {
      return 'Result #${rand.nextInt(1000)}';
    });
    return results;
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
        List<String> results = await getResults(query, false);
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
    List<String> results = await getResults(_currentQuery, true);
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
                  child: bookResult(),
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

  Widget bookResult() {
    return Row(
      children: [
        Image.network(
          "https://m.media-amazon.com/images/I/71wiGMKadmL._AC_UF1000,1000_QL80_.jpg",
          width: 150,
        ),
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text("Book Title"),
              Text("Book Author"),
            ],
          ),
        ),
      ],
    );
  }
}

