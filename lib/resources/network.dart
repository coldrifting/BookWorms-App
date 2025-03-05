import 'package:flutter/material.dart';

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

Uri childClassroomsUri(String childId) {
  return Uri.parse("$serverBaseUri/children/$childId/classrooms/all");
}

Uri childJoinClassroomUri(String childId, String classCode) {
  return Uri.parse("$serverBaseUri/children/$childId/classrooms/$classCode/join");
}

// ***** Books *****

Uri bookDetailsUri(String bookId) {
  return Uri.parse("$serverBaseUri/books/$bookId/details");
}

Uri bookDetailsAllUri(String bookId) {
  return Uri.parse("$serverBaseUri/books/$bookId/details/all");
}

Uri bookCoverUri(String bookId) {
  return Uri.parse("$serverBaseUri/books/$bookId/cover");
}

Uri bookReviewUri(String bookId) {
  return Uri.parse("$serverBaseUri/books/$bookId/review");
}

Uri bookDifficultyUri(String bookId) {
  return Uri.parse("$serverBaseUri/books/$bookId/rate-difficulty");
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

Uri bookshelvesRecommendAuthorsUri(String childId) {
  return Uri.parse("$serverBaseUri/recommend/sameauthors?childId=$childId");
}

Uri bookshelvesRecommendDescriptionsUri(String childId) {
  return Uri.parse("$serverBaseUri/recommend/similardescriptions?childId=$childId");
}

// ***** Search *****

Uri searchQueryUri(String query) {
  return Uri.parse("$serverBaseUri/search?query=$query");
}

Uri advancedSearchQueryUri(String? query, RangeValues? levelRange, double? selectedRating, List<String>? selectedGenres, List<String>? selectedTopics) {
  String uriString = "$serverBaseUri/search?";
  if (query != null) {
    uriString += "query=$query&";
  }
  if (levelRange != null) {
    uriString += "levelMin=${levelRange.start.toInt()}&levelMax=${levelRange.end.toInt()}&";
  }
  if (selectedRating != null) {
    uriString += "ratingMin=$selectedRating&";
  }
  if (selectedGenres != null) {
    for (String genre in selectedGenres) {
      uriString += "subjects=$genre&";
    }
  }
  if (selectedTopics != null) {
    for (String topic in selectedTopics) {
      uriString += "subjects=$topic&";
    }    
  }
  if (uriString.endsWith("&"))
  {
    uriString = uriString.substring(0, uriString.length - 1);
  }
  return Uri.parse(uriString);
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

const String serverBaseUri = "https://bookworms.app";