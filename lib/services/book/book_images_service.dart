import 'package:bookworms_app/resources/network.dart';

/// The [BookImagesService] handles the retrieval of book images from the server.
class BookImagesService {
  Future<List<String>> getBookImages(List<String> bookIds) async {
    List<String> bookImageURLs = bookIds.map((bookId) {
      return bookCoverUri(bookId).toString();
    }).toList();

    return bookImageURLs;
  }
}
