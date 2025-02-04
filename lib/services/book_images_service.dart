import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:bookworms_app/services/services_shared.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:archive/archive.dart';
import 'package:path_provider/path_provider.dart';

/// The [BookImagesService] handles the retrieval of book images from the server.
class BookImagesService {
  final http.Client client;

  BookImagesService({http.Client? client}) : client = client ?? http.Client();

  Future<String> _getFilePath(String bookId) async {
    final directory = await getApplicationDocumentsDirectory();
    return '${directory.path}/$bookId.jpg';
  }

  Future<bool> _isImageCached(String bookId) async {
    final filePath = await _getFilePath(bookId);
    return File(filePath).exists();
  }

  Future<Image> _getImageFromCache(String bookId) async {
    final filePath = await _getFilePath(bookId);
    return Image.file(File(filePath));
  }

  Future<void> _saveImageToCache(String bookId, Uint8List imageData) async {
    final filePath = await _getFilePath(bookId);
    final file = File(filePath);
    await file.writeAsBytes(imageData);
  }

  Future<List<Image>> getBookImages(List<String> bookIds) async {
    Map<String, Image> cachedImages = {};
    List<String> uncachedBookIds = [];

    for (var bookId in bookIds) {
      if (await _isImageCached(bookId)) {
        cachedImages[bookId] = await _getImageFromCache(bookId);
      } else {
        uncachedBookIds.add(bookId);
      }
    }

    if (uncachedBookIds.isNotEmpty) {
      Map<String, Image> fetchedImages = await _fetchAndCacheBookImages(uncachedBookIds);
      cachedImages.addAll(fetchedImages);
    }

    return bookIds.map((id) => cachedImages[id] ?? Image.asset("assets/images/book_cover_unavailable.jpg")).toList();
  }

   Future<Map<String, Image>> _fetchAndCacheBookImages(List<String> bookIds) async {
    final response = await client.post(
      Uri.parse('http://${ServicesShared.serverAddress}/books/covers'),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json'
      },
      body: json.encode(bookIds),
    );

    Map<String, Image> bookImages = {};

    if (response.statusCode == 200) {
      final archive = ZipDecoder().decodeBytes(response.bodyBytes);
      for (var file in archive) {
        final fileName = file.name.substring(0, file.name.length - 10);
        final imageData = file.content as List<int>;
        final imageBytes = Uint8List.fromList(imageData);
        await _saveImageToCache(fileName, imageBytes);
        bookImages[fileName] = Image.memory(imageBytes);
      }
    }
    return bookImages;
  }
}