import 'package:bookworms_app/resources/network.dart';

/// The [BookImagesService] handles the retrieval of book images from the server.
class BookImagesService {
  //final HttpClientExt client;
  //BookImagesService({HttpClientExt? client}) : client = client ?? HttpClientExt();

  Future<List<String>> getBookImages(List<String> bookIds) async {
    List<String> bookImageURLs = bookIds.map((bookId) {
      return bookCoverUri(bookId).toString();
    }).toList();

    return bookImageURLs;
  }

  // TODO - Replace this? or use platform specific code?

  /*
  Future<String> _getFilePath(String bookId) async {
    final directory = await getApplicationCacheDirectory();
    return '${directory}/$bookId.jpg';
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

   Future<Map<String, Image>> _fetchAndCacheBookImages(List<String> bookIds) async {
    final request = await client.postUrl(bookCoversAllUri);
    request.headers.contentType = ContentType('application', 'json', charset: 'utf-8');
    request.write(jsonEncode(bookIds));
    final response = await request.close();

    Map<String, Image> bookImages = {};

    final data = await response.first;

    if (response.ok) {
      final archive = ZipDecoder().decodeBytes(data);
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
  */
}
