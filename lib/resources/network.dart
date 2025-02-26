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

Uri childEditDetailsUri(String childId) {
  return Uri.parse("$serverBaseUri/children/$childId/edit");
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

Uri bookshelvesDetailsUri(String childId, String type, String bookshelfName) {
  return Uri.parse("$serverBaseUri/children/$childId/shelves/$type/$bookshelfName/details");
}

Uri bookshelvesAddUri(String childId, String bookshelfName) {
  return Uri.parse("$serverBaseUri/children/$childId/shelves/$bookshelfName/add");
}

Uri bookshelvesRenameUri(String childId, String oldBookshelfName, String newBookshelfName) {
  return Uri.parse("$serverBaseUri/children/$childId/shelves/$oldBookshelfName/rename?newName=$newBookshelfName");
}

Uri bookshelvesInsertUri(String childId, String bookshelfName, String bookId) {
  return Uri.parse("$serverBaseUri/children/$childId/shelves/$bookshelfName/insert?bookId=$bookId");
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

// ***** Classrooms - Teachers *****

Uri classroomDetailsUri() {
  return Uri.parse("$serverBaseUri/homeroom/details");
}

Uri createClassroomUri(String className) {
  return Uri.parse("$serverBaseUri/homeroom/create?className=$className");
}

Uri renameClassroomUri(String className) {
  return Uri.parse("$serverBaseUri/homeroom/rename?newClassName=$className");
}

Uri deleteClassroomUri() {
  return Uri.parse("$serverBaseUri/homeroom/delete");
}

Uri createClassroomBookshelfUri(String bookshelfName) {
  return Uri.parse("$serverBaseUri/homeroom/shelves/$bookshelfName/create");
}

Uri renameClassroomBookshelfUri(String bookshelfName, String newBookshelfName) {
  return Uri.parse("$serverBaseUri/homeroom/shelves/$bookshelfName/rename?newBookshelfName=$newBookshelfName");
}

Uri insertIntoClassroomBookshelfUri(String bookshelfName, String bookId) {
  return Uri.parse("$serverBaseUri/homeroom/shelves/$bookshelfName/insert?bookId=$bookId");
}

Uri removeBookFromClassroomBookshelfUri(String bookshelfName, String bookId) {
  return Uri.parse("$serverBaseUri/homeroom/shelves/$bookshelfName/remove?bookId=$bookId");
}

Uri deleteClassroomBookshelfUri(String bookshelfName) {
  return Uri.parse("$serverBaseUri/homeroom/shelves/$bookshelfName/delete");
}

// ***** Other *****

Uri getFullUri(String path) {
  return Uri.parse("$serverBaseUri$path");
}

const String serverBaseUri = "https://api.bookworms.app";
