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

  var _currentQuery = "";
  var _searchResults = [];
  Timer? _debounceTimer;

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
      if(_debounceTimer != null) {
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
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SearchBar(
                onChanged: _onSearchChanged,
                leading: const Icon(Icons.search),
                padding: const WidgetStatePropertyAll<EdgeInsets>(
                    EdgeInsets.symmetric(horizontal: 16.0)),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _searchResults.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_searchResults[index]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
