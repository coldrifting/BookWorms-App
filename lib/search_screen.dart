import 'dart:async';

import 'package:flutter/material.dart';
//import 'package:provider/provider.dart';
import 'dart:math';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  static const _defaultResponseLength = 10;
  static const _expandedResponseLength = 50;

  var _activeSearch = false;
  var _currentQuery = "";
  var _searchResults = [];
  Timer? _debounceTimer;
  late FocusNode _focusNode;
  late TextEditingController _controller;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(_focusListener);
    _controller = TextEditingController();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _controller.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  void _focusListener() {
    setState(() {
      _activeSearch = _focusNode.hasFocus;
    });
    if  (_activeSearch) {
      _focusNode.removeListener(_focusListener);
    }
  } 

  void exitActiveSearch() {
    setState(() {
      if (_focusNode.hasFocus) {
        _focusNode.unfocus();
      }
      else {
        _activeSearch = false;
      }
      _searchResults.clear();
      _controller.clear();
    });
    _focusNode.addListener(_focusListener);
  }

  // TEMPORARY FOR TESTING
  Future<List<String>> getResults(String query, bool expanded) async {
    await Future.delayed(const Duration(milliseconds: 200));
    Random rand = Random();
    var count = expanded ? _expandedResponseLength : _defaultResponseLength;
    List<String> results = List.generate(count, (index) {
      return 'Result #${rand.nextInt(1000)}';
    });
    return results;
  }

  void _onSearchChanged(String query) async {
    _currentQuery = query;
    if (_debounceTimer != null) {
      _debounceTimer!.cancel();
    }
    _debounceTimer = Timer(const Duration(milliseconds: 300), () async {
      if (query.isNotEmpty) {
        List<String> results = await getResults(query, false);
        if (_currentQuery.isNotEmpty && _focusNode.hasFocus) {
          setState(() {
            _searchResults = results;
          });
          if(_scrollController.hasClients) {
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
      child: Scaffold(
        body: Center(
          child: Column(
            children: [
              searchBar(),
              Expanded(
                child: !_activeSearch
                    ? Center(child: browseScreen())
                    : _searchResults.isEmpty
                      ? Center(child: recentsScreen())
                      : resultsScreen()
              ),
            ],
          ),
        ),
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
              controller: _controller,
              onChanged: _onSearchChanged,
              shape: WidgetStateProperty.all(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              )),
              shadowColor: const WidgetStatePropertyAll(Colors.transparent),
            ),
          ),
        if (_activeSearch) 
          Row(
            children: [
              const SizedBox(width: 8.0),
              TextButton(
                onPressed: exitActiveSearch,
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
        if(index != _searchResults.length) {
          return Column(
            children: [
              ListTile(
                title: Text(_searchResults[index]),
              ),
              const Divider(
                color: Colors.grey,
              )
            ],
          );
        } else if (_searchResults.length == 10) {
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
      }
    );
  }
}

