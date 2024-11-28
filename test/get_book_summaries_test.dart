import 'dart:convert';
import 'package:bookworms_app/models/book_summary.dart';
import 'package:bookworms_app/services/book_summaries_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'mocks/get_book_summaries_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  group('SearchService', () {
    late BookSummariesService bookSummariesService;
    late MockClient mockClient;

    setUp(() {
      mockClient = MockClient();
      bookSummariesService = BookSummariesService(client: mockClient);
    });

    test('returns a list of BookSummaries if the http call completes successfully', () async {
      final mockResponse = jsonEncode([
        {
          'bookId': '1',
          'title': 'Book 1',
          'authors': ['Author 1'],
          'difficulty': 'easy',
          'rating': 1.0
        },
        {
          'bookId': '2',
          'title': 'Book 2',
          'authors': ['Author 2'],
          'difficulty': 'medium',
          'rating': 2.0
        }
      ]);
      
      when(mockClient.get(Uri.parse('http://10.0.2.2:5247/search/title?query=test')))
          .thenAnswer((_) async => http.Response(mockResponse, 200));

      final result = await bookSummariesService.getBookSummaries('test', 2);

      expect(result, isA<List<BookSummary>>());
      expect(result.length, 2);

      expect(result[0].id, '1');
      expect(result[0].title, 'Book 1');
      expect(result[0].authors, ['Author 1']);
      expect(result[0].difficulty, 'easy');
      expect(result[0].rating, 1.0);

      expect(result[1].id, '2');
      expect(result[1].title, 'Book 2');
      expect(result[1].authors, ['Author 2']);
      expect(result[1].difficulty, 'medium');
      expect(result[1].rating, 2.0);
    });

    test('throws an exception if the http call fails', () async {
      when(mockClient.get(Uri.parse('http://10.0.2.2:5247/search/title?query=test')))
          .thenAnswer((_) async => http.Response('Not Found', 404));

      expect(() async => await bookSummariesService.getBookSummaries('test', 2), throwsException);
    });
  });
}