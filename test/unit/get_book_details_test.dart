import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

import 'package:bookworms_app/models/book_details.dart';
import 'package:bookworms_app/models/user_review.dart';
import 'package:bookworms_app/resources/network.dart';
import 'package:bookworms_app/services/book/book_details_service.dart';

import 'package:mockito/mockito.dart';
import 'mocks/http_client_test.mocks.dart';

void main() {
  group('BookSummariesService', () {
    late BookDetailsService bookDetailsService;
    late MockClient mockClient;

    setUpAll(() {
      TestWidgetsFlutterBinding.ensureInitialized();
      FlutterSecureStorage.setMockInitialValues({});
    });

    setUp(() {
      mockClient = MockClient();
      bookDetailsService = BookDetailsService(client: mockClient);
    });

    test('returns a BookDetails object if the http call completes successfully', () async {
      final mockResponse = jsonEncode(
        {
          'description': 'Description',
          'subjects': ['Subject'],
          'isbn10': 'Isbn10',
          'isbn13': 'Isbn13',
          'publishYear': 2014,
          'pageCount': 1,
          'reviews': [
            {
              "reviewerFirstName": "ReviewerFirstName",
              "reviewerLastName": "ReviewerLastName",
              "reviewerRole": "ReviewerRole",
              "reviewerIcon": 2,
              "starRating": 1,
              "reviewText": "ReviewText"
            },
          ]
        },
      );

      when(mockClient.get(bookDetailsAllUri("id"), headers: {"Accept": "application/json"}))
          .thenAnswer((_) async => http.Response(mockResponse, 200));

      final result = await bookDetailsService.getBookDetails('id');

      expect(result, isA<BookDetails>());

      expect(result.description, 'Description');
      expect(result.subjects, ['Subject']);
      expect(result.isbn10, 'Isbn10');
      expect(result.isbn13, 'Isbn13');
      expect(result.publishYear, 2014);
      expect(result.pageCount, 1);

      expect(result.reviews, isA<List<UserReview>>());
      expect(result.reviews.length, 1);

      expect(result.reviews[0].firstName, "ReviewerFirstName");
      expect(result.reviews[0].lastName, "ReviewerLastName");
      expect(result.reviews[0].role, "ReviewerRole");
      expect(result.reviews[0].icon, 2);
      expect(result.reviews[0].text, "ReviewText");
      expect(result.reviews[0].starRating, 1);
    });

    test('throws an exception if the http call fails', () async {
      when(mockClient.get(bookDetailsAllUri("id"), headers: {"Accept": "application/json"}))
          .thenAnswer((_) async => http.Response('Not Found', 404));

      expect(() async => await bookDetailsService.getBookDetails('id'), throwsException);
    });
  });
}
