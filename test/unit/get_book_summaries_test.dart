import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';

import 'package:bookworms_app/models/book_summary.dart';
import 'package:bookworms_app/resources/network.dart';
import 'package:bookworms_app/services/book/book_search_service.dart';

import 'package:mockito/mockito.dart';
import 'mocks/http_client_test.mocks.dart';

void main() {
  group('BookSummariesService', () {
    late BookSummariesService bookSummariesService;
    late MockHttpClient mockClient;

    setUp(() {
      mockClient = MockHttpClient();
      bookSummariesService = BookSummariesService(client: mockClient);
    });

    test('returns a list of BookSummaries if the http call completes successfully', () async {
      final mockResponse = jsonEncode([
        {
          'bookId': 'Id 1',
          'title': 'Title 1',
          'authors': ['Author 1'],
          'difficulty': 'Difficulty 1',
          'rating': 1.0
        },
        {
          'bookId': 'Id 2',
          'title': 'Title 2',
          'authors': ['Author 2'],
          'difficulty': 'Difficulty 2',
          'rating': 2.0
        }
      ]);
      
      when(mockClient.getUrl(searchQueryUri("test")))
          .thenAnswer((_) async => http.Response(mockResponse, 200));

      final result = await bookSummariesService.getBookSummaries('test', 2);

      expect(result, isA<List<BookSummary>>());
      expect(result.length, 2);

      expect(result[0].id, 'Id 1');
      expect(result[0].title, 'Title 1');
      expect(result[0].authors, ['Author 1']);
      expect(result[0].difficulty, 'Difficulty 1');
      expect(result[0].rating, 1.0);

      expect(result[1].id, 'Id 2');
      expect(result[1].title, 'Title 2');
      expect(result[1].authors, ['Author 2']);
      expect(result[1].difficulty, 'Difficulty 2');
      expect(result[1].rating, 2.0);
    });

    test('throws an exception if the http call fails', () async {
      when(mockClient.getUrl(searchQueryUri("test")))
          .thenAnswer((_) async => http.Response('Not Found', 404));

      expect(() async => await bookSummariesService.getBookSummaries('test', 2), throwsException);
    });
  });
}