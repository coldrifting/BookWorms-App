import 'dart:async';
import 'package:bookworms_app/resources/theme.dart';
import 'package:bookworms_app/screens/search/advanced_search_results_screen.dart';
import 'package:flutter/material.dart';

import 'package:bookworms_app/screens/search/browse_screen.dart';
import 'package:bookworms_app/screens/search/recents_screen.dart';
import 'package:bookworms_app/models/book/book_summary.dart';
import 'package:bookworms_app/services/book/book_images_service.dart';
import 'package:bookworms_app/services/book/book_search_service.dart';
import 'package:bookworms_app/resources/colors.dart';
import 'package:bookworms_app/utils/widget_functions.dart';
import 'package:bookworms_app/widgets/book_summary_widget.dart';

/// The [SearchScreen] consists of a search bar and a sub-widget (either browse, recents, or results).
class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

/// The state of the [SearchScreen].
class _SearchScreenState extends State<SearchScreen> with SingleTickerProviderStateMixin {
  var _isInActiveSearch = false;
  var _isInAdvancedSearch = false; 
  var _currentQuery = "";
  var _searchResults = [];
  Timer? _debounceTimer;

  late BookSummariesService _bookSummariesService;
  late BookImagesService _bookImagesService;

  late FocusNode _focusNode;
  late TextEditingController _textEditingcontroller;
  late ScrollController _scrollController;
  late TabController _tabController;


  final _searchHeaders = [["Reading Level", "A", "B", "C", "D", "E", "F", "G", "H"],
    ["Popular Topics", "Space", "Dinosaurs", "Ocean Life", "Cats", "Food", "Fairytale"],
    ["Popular Themes", "Courage", "Kindness", "Empathy", "Bravery", "Integrity", "Respect"],
    ["BookWorms Ratings", "9+", "8+", "7+", "6+"]];

  @override
  void initState() {
    super.initState();
    _bookSummariesService = BookSummariesService();
    _bookImagesService = BookImagesService();
    _focusNode = FocusNode();
    _focusNode.addListener(_onSearchBarFocusChanged);
    _textEditingcontroller = TextEditingController();
    _scrollController = ScrollController();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_onTabChanged);
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _focusNode.dispose();
    _textEditingcontroller.dispose();
    _scrollController.dispose();
    _tabController.dispose();
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

      _isInAdvancedSearch = false;
      _currentQuery = "";
      _searchResults.clear();
      _textEditingcontroller.clear();
    });

    // Reregister the search listener.
    _focusNode.addListener(_onSearchBarFocusChanged);
  }

  /// Callback for when the tab is changed.
  /// Sets the state of the tabs.
  void _onTabChanged() {
    setState(() {
      _isInAdvancedSearch = _tabController.index == 1;
    });
  }

  /// Fetches the search results and the corresponding images.
  Future<List<BookSummary>> search(String query) async {
    List<BookSummary> bookSummaries = await _bookSummariesService.getBookSummaries(query);
    List<String> bookIds = bookSummaries.map((bookSummary) => bookSummary.id).toList();
    List<String> bookImages = await _bookImagesService.getBookImages(bookIds);
    for (int i = 0; i < bookSummaries.length; i++) {
      bookSummaries[i].setImage(bookImages[i]);
    }
    return bookSummaries;
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
        List<BookSummary> results = await search(query);

        // Update the search results if the most recent state of the query is non-empty and the search bar is focused.
        if (_focusNode.hasFocus) {
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

  /// The search screen consists of a search bar and a sub-widget (either browse, recents, or results).
  @override
  Widget build(BuildContext context) {
    // The sub-widget is determined by the current search status.
    Widget mainContent;
    if (!_isInActiveSearch) {
      mainContent = const BrowseScreen();
    } else if (_currentQuery.isEmpty) {
      mainContent = _recentsAdvancedSearchTabs();
    } else if (_searchResults.isNotEmpty) {
      mainContent = _resultsScreen();
    } else {
      mainContent = _noResultsScreen();
    }

    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: defaultOverlay(),
        title: Text(
          "Search",
          style: const TextStyle(
            color: colorWhite
          )
        ),
        backgroundColor: colorGreen,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          children: [
            addVerticalSpace(8),
            _searchBar(),
            addVerticalSpace(8),
            Expanded(child: mainContent),
          ],
        ),
      ),
    );
  }

  /// Search queries are entered in the search bar widget.
  Widget _searchBar() {
    return Row(
      children: [
        Expanded(
          child: SearchBar(
            leading: const Icon(Icons.search),
            hintText: "Find a book",
            focusNode: _focusNode,
            controller: _textEditingcontroller,
            onChanged: !_isInAdvancedSearch ? _onSearchQueryChanged : null,
            shape: WidgetStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              )
            ),
            shadowColor: const WidgetStatePropertyAll(Colors.transparent),
          ),
        ),
        if (_isInActiveSearch)
          TextButton(
            onPressed: _onCancelPressed,
            style: TextButton.styleFrom(
              foregroundColor: colorBlack,
            ),
            child: const Text("Cancel"),
          ),
      ],
    );
  }

  /// Sub-widget containing the search results corresponding to the most recently processed search query.
  Widget _resultsScreen() {
    return ListView.builder(
      controller: _scrollController,
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        return Column(
          children: [
            BookSummaryWidget(book: _searchResults[index]),
            const Divider(color: colorGrey)
          ],
        );
      }
    );
  }

  /// Sub-widget displayed when there are no search results.
  Widget _noResultsScreen() {
    return Center(
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

  /// Sub-widget containing the recents and advanced search tabs.
  Widget _recentsAdvancedSearchTabs() {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: "Recents"),
              Tab(text: "Advanced Search"),
            ],
            unselectedLabelColor: colorGrey,
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                Center(child: RecentsScreen()),
                Center(child: _advancedSearchScreen()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Sub-widget containing advanced search functionality.
  Widget _advancedSearchScreen() {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: List.generate(4, (index) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(_searchHeaders[index][0], style: textTheme.titleMedium),
                  addVerticalSpace(8),
                  SizedBox(
                    height: 45,
                    child: _filterScrollList(textTheme, index),
                  ),
                  addVerticalSpace(16),
                ],
              );
            }),
          ),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AdvancedSearchResultsScreen()
                      )
                    );                    
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: colorWhite,
                    backgroundColor: colorGreen,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                    ),
                    minimumSize: Size(double.infinity, 64), 
                  ),
                  child: Text('Search'),
                ),
              ),
            ],
          ),  
        ],
      ),
    );
  }

  // Horizontal list of scrollable filters.
  Widget _filterScrollList(TextTheme textTheme, int headerIndex) {
    return ListView.builder(
      itemCount: _searchHeaders[headerIndex].length - 1,
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: colorGreen,
              border: Border.all(color: Colors.transparent),
              borderRadius: BorderRadius.circular(4),
            ),
            alignment: Alignment.center,
            child: TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(padding: EdgeInsets.zero),
              child: Text(
                _searchHeaders[headerIndex][index + 1],
                style: textTheme.bodyLargeWhite,
              ),
            ),
          ),
        );
      },
    );
  }
}