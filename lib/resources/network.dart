final Uri userLoginUri = getFullUri("/user/login");
final Uri userRegisterUri = getFullUri("/user/register");
final Uri userDetailsUri = getFullUri("/user/details");
final Uri userDeleteUri = getFullUri("/user/delete");
final Uri childrenAllUri = getFullUri("/children/all");
final Uri bookCoversBatchUri = getFullUri("/books/covers");

  // ***** Children *****

Uri childAddUri(String childName) {
  return Uri.parse("$serverBaseUri/children/add?childName=$childName");
}

// ***** Books *****

Uri bookDetailsUri(String bookId) {
  return Uri.parse("$serverBaseUri/books/$bookId/details");
}

Uri bookDetailsAllUri(String bookId) {
  return Uri.parse("$serverBaseUri/books/$bookId/details/all");
}

Uri bookReviewUri(String bookId) {
  return Uri.parse("$serverBaseUri/books/$bookId/review");
}

Uri bookCoverUri(String bookId) {
  return Uri.parse("$serverBaseUri/books/$bookId/cover");
}

// ***** Bookshelves *****

Uri bookshelvesUri(String childId) {
  return Uri.parse("$serverBaseUri/children/$childId/shelves");
}

Uri bookshelvesDetailsUri(String childId, String bookshelfName) {
  return Uri.parse("$serverBaseUri/children/$childId/shelves/$bookshelfName/details");
}


Uri bookshelvesAddUri(String childId, String bookshelfName) {
  return Uri.parse("$serverBaseUri/children/$childId/shelves/$bookshelfName/add");
}

Uri bookshelvesRenameUri(String childId, String oldBookshelfName, String newBookshelfName) {
  return Uri.parse("$serverBaseUri/children/$childId/shelves/$oldBookshelfName/rename?newName=$newBookshelfName");
}

Uri bookshelvesInsertUri(String childId, String bookshelfName) {
  return Uri.parse("$serverBaseUri/children/$childId/shelves/$bookshelfName/insert");
}

Uri bookshelvesRemoveUri(String childId, String bookshelfName, String bookId) {
  return Uri.parse("$serverBaseUri/children/$childId/shelves/$bookshelfName/remove?bookId=$bookId");
}

Uri bookshelvesClearUri(String childId, String bookshelfName) {
  return Uri.parse("$serverBaseUri/children/$childId/shelves/$bookshelfName/clear");
}

Uri bookshelvesDeleteUri(String childId, String bookshelfName) {
  return Uri.parse("$serverBaseUri/children/$childId/shelves/$bookshelfName/delete");
}

// ***** Search *****

Uri searchQueryUri(String query) {
  return Uri.parse("$serverBaseUri/search?query=$query");
}

Uri getFullUri(String path) {
  return Uri.parse("$serverBaseUri$path");
}

const String serverBaseUri = "https://c7ad-2601-681-5f04-d080-4065-1b4-ac65-ee86.ngrok-free.app";