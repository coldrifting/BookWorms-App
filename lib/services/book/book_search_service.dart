import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:bookworms_app/resources/network.dart';
import 'package:bookworms_app/utils/http_helpers.dart';
import 'package:bookworms_app/models/book/book_summary.dart';

/// The [SearchService] handles the retrieval of book summaries from the server.
class SearchService {
  final http.Client client;

  SearchService({http.Client? client}) : client = client ?? http.Client();

  // Retrieve and decode the book summaries of the given query from the server.
  Future<List<BookSummary>> search(String query) async {
    final response = await client.sendRequest(
        uri: searchQueryUri(query),
        method: "GET");

    if (response.ok) {
      return fromResponseListBookSummary(response);
    }
    else {
      throw Exception('An error occurred when fetching book summaries.');
    }
  }

  // Retrieve and decode the book summaries of the given query and filters from the server.
  Future<List<BookSummary>> advancedSearch(String? query, RangeValues? levelRange, double? selectedRating, List<String>? selectedGenres, List<String>? selectedTopics) async {
    final response = await client.sendRequest(
      uri: advancedSearchQueryUri(query, levelRange, selectedRating, selectedGenres, selectedTopics),
      method: "GET");

    if (response.ok) {
      return fromResponseListBookSummary(response);
    }
    else {
      throw Exception('An error occurred when fetching book summaries.');
    }
  }
}