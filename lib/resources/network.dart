final Uri userLoginUri = getFullUri("/user/login");
final Uri userRegisterUri = getFullUri("/user/register");
final Uri userDetailsUri = getFullUri("/user/details");
final Uri userDeleteUri = getFullUri("/user/delete");
final Uri childrenAllUri = getFullUri("/children/all");
final Uri bookCoversBatchUri = getFullUri("/books/covers");

Uri childAddUri(String childName) {
  return Uri.parse("$serverBaseUri/children/add?childName=$childName");
}

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

Uri searchQueryUri(String query) {
  return Uri.parse("$serverBaseUri/search?query=$query");
}


Uri getFullUri(String path) {
  return Uri.parse("$serverBaseUri$path");
}

const String serverBaseUri = "https://62f3-2601-681-4000-1430-31b4-12e6-25bd-1ed8.ngrok-free.app:443";