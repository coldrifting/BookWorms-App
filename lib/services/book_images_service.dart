import 'dart:convert';
import 'dart:typed_data';
import 'package:bookworms_app/services/services_shared.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:archive/archive.dart';

/// The [BookDetailsService] handles the retrieval of book images from the server.
class BookImagesService {
  final http.Client client;

  BookImagesService({http.Client? client}) : client = client ?? http.Client();

// Retrieve and decode the book images of the book ids from the server.
  Future<List<Image>> getBookImages(List<String> bookIds) async {
    final response = await client.post(
      Uri.parse('http://${ServicesShared.serverAddress}/books/covers'),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json'
      },
      body: json.encode(bookIds)
    );
    if (response.statusCode == 200) {
      final List<int> bytes = response.bodyBytes;
      final archive = ZipDecoder().decodeBytes(Uint8List.fromList(bytes));
      List<Image> images = [];
      for (var file in archive) {
        final imageData = file.content as List<int>;
        final image = Image.memory(Uint8List.fromList(imageData));
        images.add(image);
      }
      return images;
    } else {
      throw Exception('An error occurred when fetching the book image.');
    }
  }
}