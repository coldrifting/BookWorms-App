import 'dart:async';

import 'package:bookworms_app/models/book/book_summary.dart';
import 'package:bookworms_app/resources/theme.dart';
import 'package:bookworms_app/screens/search/advanced_search_results_screen.dart';
import 'package:bookworms_app/screens/search/no_results_screen.dart';
import 'package:bookworms_app/screens/search/recents_screen.dart';
import 'package:bookworms_app/services/book/book_images_service.dart';
import 'package:bookworms_app/services/book/book_search_service.dart';
import 'package:bookworms_app/showcase/showcase_controller.dart';
import 'package:bookworms_app/showcase/showcase_widgets.dart';
import 'package:bookworms_app/utils/widget_functions.dart';
import 'package:bookworms_app/widgets/announcements_widget.dart';
import 'package:bookworms_app/widgets/app_bar_custom.dart';
import 'package:bookworms_app/widgets/book_summary_widget.dart';
import 'package:bookworms_app/widgets/reading_level_info_widget.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spell_checker/flutter_spell_checker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;


/// The [SearchScreen] consists of a search bar and a sub-widget (either browse, recents, or results).
class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => SearchScreenState();
}

/// The state of the [SearchScreen].
class SearchScreenState extends State<SearchScreen> with SingleTickerProviderStateMixin {
  var _isInAdvancedSearch = false; 
  var _currentQuery = "";
  var _currentQueryCorrected = [];
  var _searchResults = [];
  Timer? _debounceTimer;

  late SearchService _bookSearchService;
  late BookImagesService _bookImagesService;

  late TextEditingController _textEditingController;
  late ScrollController _scrollController;
  late TabController _tabController;

  var _selectedLevelRange = const RangeValues(0, 100);
  final _selectedRating = List.filled(6, false);
  final _selectedGenres = List.filled(6, false);
  final _selectedTopics = List.filled(6, false);

  late final showcaseController = ShowcaseController();
  late final List<GlobalKey> navKeys = showcaseController.getKeysForScreen('search');

  @override
  void initState() {
    super.initState();
    _bookSearchService = SearchService();
    _bookImagesService = BookImagesService();
    _textEditingController = TextEditingController();
    _scrollController = ScrollController();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_onTabChanged);
    _notifyIfChanged();
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _textEditingController.dispose();
    _scrollController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  /// Callback for when the tab is changed.
  /// Sets the state of the tabs.
  void _onTabChanged() {
    setState(() {
      _isInAdvancedSearch = _tabController.index == 1;
    });
    _notifyIfChanged();
  }

  void _notifyIfChanged() {
    // Notify main app of changes for proper reset
    SearchModifiedNotification(isModified: _currentQuery != "" || _isInAdvancedSearch).dispatch(context);
  }

  void reset() {
    setState(() {
      _currentQuery = "";
      _currentQueryCorrected.clear();
      _textEditingController.text = "";
      _tabController.index = 0;
      FocusManager.instance.primaryFocus?.unfocus();
    });
  }

  /// Fetches the search results and the corresponding images.
  Future<List<BookSummary>> _search(String query) async {
    List<BookSummary> bookSummaries = await _bookSearchService.search(query);
    List<String> bookIds = bookSummaries.map((bookSummary) => bookSummary.id).toList();
    List<String> bookImages = await _bookImagesService.getBookImages(bookIds);
    for (int i = 0; i < bookSummaries.length; i++) {
      bookSummaries[i].imageUrl = bookImages[i];
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

    _notifyIfChanged();

    _debounceTimer = Timer(const Duration(milliseconds: 300), () async {
      // Only fetch results if the query is non-empty.
      if (query.isNotEmpty) {
        // Check the query for typos (any found will be suggested to user)
        if (!kIsWeb) {
          await _spellcheckQuery(query);
        }

        List<BookSummary> results = await _search(query);

        // Update the search results if the most recent state of the query is non-empty and the search bar is focused.
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
      } else {
        setState(() {
          _currentQueryCorrected.clear();
          _searchResults = [];
        });
      }
    });
  }

  /// Sets state according to the results of spellchecking the given query.
  Future<void> _spellcheckQuery(String query) async {
    final spellCheckResult = await FlutterSpellChecker.checkSpelling(query);
    if (spellCheckResult.isNotEmpty) {
      final corrections = {
        for (var correction in spellCheckResult)
          correction.word : correction.replacements[0]
      };
      _currentQueryCorrected = [
        for (var word in _currentQuery.split(" "))
          {
            "word": corrections[word] ?? word,
            "corrected": corrections[word] != null
          }
      ];
    } else {
      _currentQueryCorrected.clear();
    }
  }

  /// Fetches the advanced search results and the corresponding images.
  void _advancedSearch() async {
    String? currentQuery = _textEditingController.text.isEmpty ? null : _textEditingController.text;

    RangeValues? selectedLevelRange = _selectedLevelRange.start == 0 && _selectedLevelRange.end == 100 ? null : _selectedLevelRange;

    List<double> ratings = [4.5, 4.0, 3.5, 3.0, 2.5, 2.0];
    double? selectedRating;
    for (int i = 0; i < _selectedRating.length; i++) {
      if (_selectedRating[i]) {
        selectedRating = ratings[i];
        break;
      }
    }

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

    List<BookSummary> bookSummaries = await _bookSearchService.advancedSearch(currentQuery, selectedLevelRange, selectedRating, selectedGenres, selectedTopics);
    List<String> bookIds = bookSummaries.map((bookSummary) => bookSummary.id).toList();
    List<String> bookImages = await _bookImagesService.getBookImages(bookIds);
    for (int i = 0; i < bookSummaries.length; i++) {
      bookSummaries[i].imageUrl = bookImages[i];
    }

    if (mounted) {
      pushScreen(context, AdvancedSearchResultsScreen(bookSummaries: bookSummaries));
    }
  }

  /// The search screen consists of a search bar and a sub-widget (either browse, recents, or results).
  @override
  Widget build(BuildContext context) {
    // The sub-widget is determined by the current search status.
    Widget mainContent;
    if (_currentQuery.isEmpty) {
      mainContent = _recentsAdvancedSearchTabs();
    } else if (_searchResults.isNotEmpty) {
      mainContent = _resultsScreen();
    } else {
      mainContent = NoResultsScreen();
    }

    return Scaffold(
      appBar: AppBarCustom("Search", isLeafPage: false, isChildSwitcherEnabled: true, rightAction: AnnouncementsWidget()) ,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          children: [
            addVerticalSpace(8),
            _searchBar(),
            if (_currentQueryCorrected.isNotEmpty)
              Column(
                children: [
                  addVerticalSpace(8),
                  _didYouMean(),
                ],
              ),
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
            controller: _textEditingController,
            onChanged: !_isInAdvancedSearch ? _onSearchQueryChanged : null,
            shape: WidgetStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              )
            ),
            shadowColor: const WidgetStatePropertyAll(Colors.transparent),
            trailing: [
              if (_textEditingController.text.isNotEmpty)
                IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _textEditingController.clear();
                    _onSearchQueryChanged("");
                  },
                ),
            ],
          ),
        ),
      ],
    );
  }

  /// The "did you mean" sub-widget is shown if typos are detected
  Widget _didYouMean() {
    final tapGestureRecognizer = TapGestureRecognizer()..onTap = () {
      _notifyIfChanged();
      setState(() {
        var corrected = _currentQueryCorrected.map((element) => element["word"]).join(" ");
        _textEditingController.text = corrected;
        _currentQueryCorrected.clear();
        _onSearchQueryChanged(corrected);
      });
    };

    return Center(
      child: RichText(
        text: TextSpan(
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w300,
            color: context.colors.onSurface
          ),
          children: <TextSpan>[
            TextSpan(text: "Did you mean: "),
            TextSpan(
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.indigoAccent
              ),
              children: [
                for (var element in _currentQueryCorrected)
                  TextSpan(
                    text: element["word"] + " ",
                    recognizer: tapGestureRecognizer,
                    style: element["corrected"]
                      ? const TextStyle(fontStyle: FontStyle.italic)
                      : null
                  )
              ]
            )
          ]
        )
      )
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
            Divider(color: context.colors.grey)
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
            tabs: [
              BWShowcase(
                  showcaseKey: navKeys[0],
                  description: "Your recently searched books will appear under this tab",
                  targetPadding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                  child: Tab(text: "Recents")
              ),
              BWShowcase(
                  showcaseKey: navKeys[1],
                  description: "Switch to this tab to access more search options",
                  targetPadding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                  child: Tab(text: "Advanced Search")
              ),
            ],
            unselectedLabelColor: context.colors.grey,
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

    var fadeColor = context.colors.surfaceBackground.withAlpha(0);

    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'Reading Level',
                        style: textTheme.titleMedium
                      ),
                      RawMaterialButton(
                        onPressed: () => pushScreen(context, const ReadingLevelInfoWidget()),
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(8.0),
                        constraints: BoxConstraints(
                          maxWidth: 40,
                        ),
                        child: const Icon(
                          Icons.help_outline,
                          size: 20
                        )
                      ),
                    ],
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
                    'Average User Rating',
                    style: textTheme.titleMedium
                  ),
                  addVerticalSpace(8),
                  SizedBox(
                    height: 50,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      physics: BouncingScrollPhysics(),
                      children: [
                        SizedBox(width: 10),
                        ToggleButtons(
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
                        addHorizontalSpace(10),
                      ],
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
                    style: textTheme.titleMedium,
                  ),
                  addVerticalSpace(8),
                  Stack(
                    children: [
                      SizedBox(
                        height: 50,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          physics: BouncingScrollPhysics(),
                          children: [
                            SizedBox(width: 12),
                            ToggleButtons(
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
                            SizedBox(width: 12),
                          ],
                        ),
                      ),
                      Positioned.fill(
                        child: IgnorePointer(
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: [
                                  context.colors.surfaceBackground,
                                  fadeColor,
                                  fadeColor,
                                  context.colors.surfaceBackground,
                                ],
                                stops: [0.0, 0.05, 0.95, 1.0],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              addVerticalSpace(16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Topics',
                    style: textTheme.titleMedium,
                  ),
                  addVerticalSpace(8),
                  Stack(
                    children: [
                      SizedBox(
                        height: 50,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          physics: BouncingScrollPhysics(),
                          children: [
                            SizedBox(width: 12),
                            ToggleButtons(
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
                            SizedBox(width: 12),
                          ],
                        ),
                      ),
                      Positioned.fill(
                        child: IgnorePointer(
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: [
                                  context.colors.surfaceBackground,
                                  fadeColor,
                                  fadeColor,
                                  context.colors.surfaceBackground,
                                ],
                                stops: [0.0, 0.05, 0.95, 1.0],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              addVerticalSpace(64),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        _advancedSearch();                 
                      },
                      style: largeButtonStyle,
                      child: Text('Search'),
                    ),
                  ),
                ],
              ),  
            ],
          ),
        ),
      ]
    );
  }
}

class SearchModifiedNotification extends Notification {
  final bool isModified;

  const SearchModifiedNotification({required this.isModified});
}