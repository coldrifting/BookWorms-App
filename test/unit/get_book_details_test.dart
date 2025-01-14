import 'dart:convert';
import 'package:bookworms_app/models/book_details.dart';
import 'package:bookworms_app/models/user_review.dart';
import 'package:bookworms_app/services/book_details_service.dart';
import 'package:bookworms_app/services/services_shared.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'mocks/http_client_test.mocks.dart';

void main() {
  group('BookSummariesService', () {
    late BookDetailsService bookDetailsService;
    late MockClient mockClient;

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
          'publisher': 'Publisher',
          'publishDate': 'PublishDate',
          'pageCount': 1,
          'reviews': [
            {
              "reviewerFirstName": "ReviewerFirstName",
              "reviewerLastName": "ReviewerLastName",
              "reviewerRole": "ReviewerRole",
              "reviewerIcon": "ReviewerIcon",
              "starRating": 1,
              "reviewText": "ReviewText"
            },
          ]
        },
      );
      
      when(mockClient.get(Uri.parse('http://${ServicesShared.serverAddress}/books/id/details')))
          .thenAnswer((_) async => http.Response(mockResponse, 200));

      final result = await bookDetailsService.getBookDetails('id');

      expect(result, isA<BookDetails>());

      expect(result.description, 'Description');
      expect(result.subjects, ['Subject']);
      expect(result.isbn10, 'Isbn10');
      expect(result.isbn13, 'Isbn13');
      expect(result.publisher, 'Publisher');
      expect(result.publishDate, 'PublishDate');
      expect(result.pageCount, 1);

      expect(result.reviews, isA<List<UserReview>>());
      expect(result.reviews.length, 1);

      expect(result.reviews[0].firstName, "ReviewerFirstName");
      expect(result.reviews[0].lastName, "ReviewerLastName");
      expect(result.reviews[0].role, "ReviewerRole");
      expect(result.reviews[0].icon, "ReviewerIcon");
      expect(result.reviews[0].text, "ReviewText");
      expect(result.reviews[0].starRating, 1);
    });

    test('throws an exception if the http call fails', () async {
      when(mockClient.get(Uri.parse('http://${ServicesShared.serverAddress}/books/id/details')))
          .thenAnswer((_) async => http.Response('Not Found', 404));

      expect(() async => await bookDetailsService.getBookDetails('id'), throwsException);
    });
  });
}