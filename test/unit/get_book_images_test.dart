import 'dart:typed_data';
import 'package:archive/archive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'package:bookworms_app/services/book_images_service.dart';
import 'package:bookworms_app/services/services_shared.dart';
import 'mocks/http_client_test.mocks.dart';

void main() {
  group('BookImagesService', () {
    late BookImagesService bookImagesService;
    late MockClient mockClient;

    setUp(() {
      mockClient = MockClient();
      bookImagesService = BookImagesService(client: mockClient);
    });

    test('returns a list of 1 image if the http call completes successfully', () async {
      final mockZipResponse = createMockZipFile(1);

      when(mockClient.post(
        Uri.parse('http://${ServicesShared.serverAddress}/books/covers'),
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).thenAnswer((_) async => http.Response.bytes(mockZipResponse, 200));

      final result = await bookImagesService.getBookImages(['id']);

      expect(result, isA<List<Image>>());
      expect(result.length, 1);
      expect(result[0], isA<Image>());
    });

    test('returns a list of 5 images if the http call completes successfully', () async {
      final mockZipResponse = createMockZipFile(5);

      when(mockClient.post(
        Uri.parse('http://${ServicesShared.serverAddress}/books/covers'),
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).thenAnswer((_) async => http.Response.bytes(mockZipResponse, 200));

      final result = await bookImagesService.getBookImages(['id']);

      expect(result, isA<List<Image>>());
      expect(result.length, 5);
      expect(result[0], isA<Image>());
    });

    test('throws an exception if the http call fails', () async {
      when(mockClient.post(
        Uri.parse('http://${ServicesShared.serverAddress}/books/covers'),
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).thenAnswer((_) async => http.Response('Not Found', 404));

      expect(() async => await bookImagesService.getBookImages(['id']), throwsException);
    });
  });
}

Uint8List createMockZipFile(int numImages) {
  final archive = Archive();
  for (int i = 0; i < numImages; i++) {
    final imageData = List<int>.generate(100, (index) => index + (i * 100));
    final fileName = 'cover$i.jpg';
    archive.addFile(ArchiveFile(fileName, imageData.length, imageData));
  }
  final zipData = ZipEncoder().encode(archive);
  return Uint8List.fromList(zipData);
}
