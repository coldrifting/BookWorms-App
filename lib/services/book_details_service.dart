import 'dart:convert';
import 'package:bookworms_app/models/BookExtended.dart';
import 'package:http/http.dart' as http;

class BookDetailsService {
  // Retrieve and decode extended book data from the server.
  Future<BookExtended> getBookExtended(String bookId) async {
    final response = await http.get(Uri.parse('http://10.0.2.2:5247/books/$bookId/details'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return BookExtended.fromJson(data);
    } else {
      throw Exception('An error occurred when fetching book details.');
    }
  }
}