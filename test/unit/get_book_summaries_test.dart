import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

import 'package:bookworms_app/models/book/book_summary.dart';
import 'package:bookworms_app/resources/network.dart';
import 'package:bookworms_app/services/book/book_search_service.dart';

import 'package:mockito/mockito.dart';
import 'mocks/http_client_test.mocks.dart';

void main() {
  group('BookSummariesService', () {
    late SearchService bookSummariesService;
    late MockClient mockClient;

    setUpAll(() {
      TestWidgetsFlutterBinding.ensureInitialized();
      FlutterSecureStorage.setMockInitialValues({});
    });

    setUp(() {
      mockClient = MockClient();
      bookSummariesService = SearchService(client: mockClient);
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
          'difficulty': null,
          'rating': 2.0
        },
        {
          'bookId': 'Id 3',
          'title': 'Title 3',
          'authors': ['Author 3'],
          'rating': 2.5
        }
      ]);
      
      when(mockClient.get(searchQueryUri("test"), headers: {"Accept": "application/json"}))
          .thenAnswer((_) async => http.Response(mockResponse, 200));

      final result = await bookSummariesService.getBookSummaries('test');

      expect(result, isA<List<BookSummary>>());
      expect(result.length, 3);

      expect(result[0].id, 'Id 1');
      expect(result[0].title, 'Title 1');
      expect(result[0].authors, ['Author 1']);
      expect(result[0].level, 'Difficulty 1');
      expect(result[0].rating, 1.0);

      expect(result[1].id, 'Id 2');
      expect(result[1].title, 'Title 2');
      expect(result[1].authors, ['Author 2']);
      expect(result[1].level, 'N/A');
      expect(result[1].rating, 2.0);

      expect(result[2].id, 'Id 3');
      expect(result[2].title, 'Title 3');
      expect(result[2].authors, ['Author 3']);
      expect(result[2].level, 'N/A');
      expect(result[2].rating, 2.5);
    });

    test('throws an exception if the http call fails', () async {
      when(mockClient.get(searchQueryUri("test"), headers: {"Accept": "application/json"}))
          .thenAnswer((_) async => http.Response('Not Found', 404));

      expect(() async => await bookSummariesService.getBookSummaries('test'), throwsException);
    });
  });
}