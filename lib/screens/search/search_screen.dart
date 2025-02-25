import 'dart:async';
import 'package:bookworms_app/screens/search/advanced_search_results_screen.dart';
import 'package:bookworms_app/screens/search/no_results_screen.dart';
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

  late SearchService _bookSearchService;
  late BookImagesService _bookImagesService;

  late FocusNode _focusNode;
  late TextEditingController _textEditingcontroller;
  late ScrollController _scrollController;
  late TabController _tabController;

  var _selectedLevelRange = const RangeValues(0, 100);
  final _selectedRating = List.filled(6, false);
  final _selectedGenres = List.filled(6, false);
  final _selectedTopics = List.filled(6, false);

  @override
  void initState() {
    super.initState();
    _bookSearchService = SearchService();
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
  Future<List<BookSummary>> _search(String query) async {
    List<BookSummary> bookSummaries = await _bookSearchService.search(query);
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
        List<BookSummary> results = await _search(query);

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

  /// Fetches the advanced search results and the corresponding images.
  void _advancedSearch() async {
    String? currentQuery = _textEditingcontroller.text.isEmpty ? null : _textEditingcontroller.text;

    int selectedRatingIndex = _selectedRating.indexOf(true);
    double? selectedRating;
    if (selectedRatingIndex == -1) {
      selectedRating = null;
    } else {
      selectedRating = (9 - selectedRatingIndex) / 2.0;
    }

    RangeValues? selectedLevelRange = _selectedLevelRange.start == 0 && _selectedLevelRange.end == 100 ? null : _selectedLevelRange;
    

    List<String> genres = ["Fantasy fiction", "Adventure and adventurers", "Mystery and detective stories", "Fiction, historical, general", "Science fiction", "Fairy tales"];
    List<String>? selectedGenres = [];
    for (int i = 0; i < _selectedGenres.length; i++) {
      if (_selectedGenres[i]) {
        selectedGenres.add(genres[i]);
      }
    }
    if (selectedGenres.isEmpty) {
      selectedGenres = null;
    }

    List<String> topics = ["Friendship, fiction", "Family life, fiction", "Magic, fiction", "Love, fiction", "Conduct of life", "Animals, fiction"];
    List<String>? selectedTopics = [];
    for (int i = 0; i < _selectedTopics.length; i++) {
      if (_selectedTopics[i]) {
        selectedTopics.add(topics[i]);
      }
    }
    if (selectedTopics.isEmpty) {
      selectedTopics = null;
    }

    List<BookSummary> bookSummaries = await _bookSearchService.advancedSearch(currentQuery, selectedRating, selectedLevelRange);
    List<String> bookIds = bookSummaries.map((bookSummary) => bookSummary.id).toList();
    List<String> bookImages = await _bookImagesService.getBookImages(bookIds);
    for (int i = 0; i < bookSummaries.length; i++) {
      bookSummaries[i].setImage(bookImages[i]);
    }

    if (mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AdvancedSearchResultsScreen(
            bookSummaries: bookSummaries
          )
        )
      );   
    }
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
      mainContent = NoResultsScreen();
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

    final ratings = [Text('4.5+'), Text('4.0+'), Text('3.5+'), Text('3.0+'), Text('2.5+'), Text('2.0+')];
    final genres = [Text('Fantasy'), Text('Adventure'), Text('Mystery'), Text('Historical Fiction'), Text('Science Fiction'), Text('Fairy Tales')];
    final topics = [Text('Friendship'), Text('Family'), Text('Magic'), Text('Love'), Text('Manners'), Text('Animals')];

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Reading Level',
                    style: textTheme.titleMedium
                  ),
                  addVerticalSpace(8),
                  Row(
                    children: [
                      Text('0'),
                      Expanded(
                        child: RangeSlider(
                          values: _selectedLevelRange,
                          max: 100,
                          divisions: 10,
                          labels: RangeLabels(
                            _selectedLevelRange.start.round().toString(),
                            _selectedLevelRange.end.round().toString(),
                          ),
                          onChanged: (RangeValues values) {
                            setState(() {
                              _selectedLevelRange = values;
                            });
                          },
                        ),
                      ),
                      Text('100')
                    ],
                  )
                ],
              ),
              addVerticalSpace(16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Bookworms Rating',
                    style: textTheme.titleMedium
                  ),
                  addVerticalSpace(8),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: ToggleButtons(
                      onPressed: (int index) {
                        setState(() {
                          for (int i = 0; i < _selectedRating.length; i++) {
                            if (i != index) {
                              _selectedRating[i] = false;
                            } else {
                              _selectedRating[i] = !_selectedRating[i];
                            }
                          }
                        });
                      },
                      isSelected: _selectedRating,
                      children: ratings.map((level) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: level,
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
              addVerticalSpace(16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Genres',
                    style: textTheme.titleMedium
                  ),
                  addVerticalSpace(8),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: ToggleButtons(
                      onPressed: (int index) {
                        setState(() {
                          _selectedGenres[index] = !_selectedGenres[index];
                        });
                      },
                      isSelected: _selectedGenres,
                      children: genres.map((level) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: level,
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
              addVerticalSpace(16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Topics',
                    style: textTheme.titleMedium
                  ),
                  addVerticalSpace(8),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: ToggleButtons(
                      onPressed: (int index) {
                        setState(() {
                          _selectedTopics[index] = !_selectedTopics[index];
                        });
                      },
                      isSelected: _selectedTopics,
                      children: topics.map((level) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: level,
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    _advancedSearch();                 
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
}