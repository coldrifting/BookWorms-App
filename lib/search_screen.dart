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
  var _activeSearch = false;
  var _currentQuery = "";
  var _searchResults = [];
  Timer? _debounceTimer;
  late FocusNode _focusNode;
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(_focusListener);
    _controller = TextEditingController();
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
  Future<List<String>> getResults(String query) async {
    await Future.delayed(const Duration(milliseconds: 200));
    Random rand = Random();
    List<String> results = List.generate(50, (index) {
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
        List<String> results = await getResults(query);
        if (_currentQuery.isNotEmpty) {
          setState(() {
            _searchResults = results;
          });
        }
      } else {
        setState(() {
          _searchResults = [];
        });
      }
    });
  }

  @override
  Widget build(BuildContext scontext) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Scaffold(
        body: Center(
          child: Column(
            children: [
              Row(
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
              ),
              Expanded(
                child: !_activeSearch
                    ? const Center(child: Text("Browse"))
                    : _searchResults.isEmpty
                      ? const Center(child: Text("Recent"))
                      : ListView.builder(
                          itemCount: _searchResults.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text(_searchResults[index]),
                            );
                          }
                      )
              ),
            ],
          ),
        ),
      ),
    );
  }
}
