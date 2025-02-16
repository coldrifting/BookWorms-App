import 'dart:collection';
import 'package:bookworms_app/services/book/bookshelf_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:bookworms_app/models/account.dart';
import 'package:bookworms_app/models/account_details.dart';
import 'package:bookworms_app/models/book_summary.dart';
import 'package:bookworms_app/models/bookshelf.dart';
import 'package:bookworms_app/models/child.dart';
import 'package:bookworms_app/models/parent_account.dart';
import 'package:bookworms_app/models/teacher_account.dart';
import 'package:bookworms_app/services/account/account_details_service.dart';
import 'package:bookworms_app/services/account/add_child_service.dart';
import 'package:bookworms_app/services/account/account_details_edit_service.dart';
import 'package:bookworms_app/services/account/get_children_service.dart';
import 'package:bookworms_app/services/book/book_images_service.dart';
import 'package:bookworms_app/services/book/book_summary_service.dart';

class AppState extends ChangeNotifier {
  late Account _account;
  late bool _isParent;
  
  Future<void> loadAccountDetails() async {
    AccountDetailsService accountDetailsService = AccountDetailsService();
    AccountDetails accountDetails = await accountDetailsService.getAccountDetails();
    ListQueue<BookSummary> recentBooks = await loadRecentsFromCache();
    if (accountDetails.role == "Parent") {
      _account = Parent(
        username: accountDetails.username,
        firstName: accountDetails.firstName,
        lastName: accountDetails.lastName,
        profilePictureIndex: accountDetails.profilePictureIndex,
        recentlySearchedBooks: recentBooks,
        children: [],
        selectedChildID: 0
      );
    } else {
      _account = Teacher(
        username: accountDetails.username,
        firstName: accountDetails.firstName,
        lastName: accountDetails.lastName,
        profilePictureIndex: accountDetails.profilePictureIndex,
        recentlySearchedBooks: recentBooks
      );
    }
    _isParent = _account is Parent;
  }

  Future<void> loadAccountSpecifics() async {
    if (_isParent) {
      GetChildrenService getChildrenService = GetChildrenService();
      List<Child> children = await getChildrenService.getChildren();
      (_account as Parent).children = children;
    }
  }

  List<Child> get children => (_account as Parent).children;
  int get selectedChildID => (_account as Parent).selectedChildID;

  Future<void> addChild(String childName) async {
    AddChildService addChildService = AddChildService();
    Child newChild = await addChildService.addChild(childName);
    (_account as Parent).children.add(newChild);
    notifyListeners();
  }

  void removeChild(int childID) {
    (_account as Parent).children.removeAt(childID);
    notifyListeners();
  }
  
  void editChildName(int childID, String newName) {
    (_account as Parent).children[childID].name = newName;
    notifyListeners();
  }

  void setSelectedChild(int childID) {
    (_account as Parent).selectedChildID = childID;
    notifyListeners();
  }

    void setChildIconIndex(int childId, int index) {
    (_account as Parent).children[childId].profilePictureIndex = index;
    notifyListeners();
  }

  // ***** Bookshelves *****

  BookshelfService bookshelvesService = BookshelfService();

  void setChildBookshelves(int childId) async {
    String guid = children[childId].id;
    List<Bookshelf> bookshelves = await bookshelvesService.getBookshelves(guid);
    (_account as Parent).children[childId].bookshelves = bookshelves;
    notifyListeners();
  }

  Future<Bookshelf> getChildBookshelf(int childId, Bookshelf bookshelf) async {
    String guid = children[childId].id;
    Bookshelf childBookshelf = await bookshelvesService.getBookshelf(guid, bookshelf.name);
    return childBookshelf;
  }

  void addChildBookshelf(int childId, Bookshelf bookshelf) async {
    String guid = children[childId].id;
    List<Bookshelf> bookshelves = await bookshelvesService.addBookshelf(guid, bookshelf.name);
    (_account as Parent).children[childId].bookshelves = bookshelves;
    notifyListeners();
  }

  void renameChildBookshelf(int childId, Bookshelf bookshelf, String newName) async {
    String guid = children[childId].id;
    List<Bookshelf> bookshelves = await bookshelvesService.renameBookshelfService(guid, bookshelf.name, newName);
    (_account as Parent).children[childId].bookshelves = bookshelves;
    notifyListeners();
  }

  void deleteChildBookshelf(int childId, Bookshelf bookshelf) async {
    String guid = children[childId].id;
    List<Bookshelf> bookshelves = await bookshelvesService.deleteBookshelf(guid, bookshelf.name);
    (_account as Parent).children[childId].bookshelves = bookshelves;
    notifyListeners();
  }


  // ***** Account *****

  Account get account => _account;
  bool get isParent => _isParent;
  String get firstName => _account.firstName;
  String get lastName => _account.lastName;
  String get username => _account.username;

  // Updates account information on server and locally.
  void editAccountInfo({String? firstName, String? lastName, int? profilePictureIndex}) async {
    // If not included as parameters, set to currently-saved value.
    firstName ??= _account.firstName;
    lastName ??= _account.lastName;
    profilePictureIndex ??= _account.profilePictureIndex;

    AccountDetailsEditService accountService = AccountDetailsEditService();
    AccountDetails accountDetails = await accountService.setAccountDetails(firstName, lastName, profilePictureIndex);

    _account.firstName = accountDetails.firstName;
    _account.lastName = accountDetails.lastName;
    _account.profilePictureIndex = accountDetails.profilePictureIndex;
    notifyListeners();
  }

  List<BookSummary> get recentlySearchedBooks => _account.recentlySearchedBooks.toList();

  // Adds the given book ID to the list of recently searched books.
  // If the list is larger than 10 books, the last ID is deleted before
  // the new ID is added.
  void addBookToRecents(BookSummary bookSummary) async {
    bool exists = _account.recentlySearchedBooks.any((book) => book.id == bookSummary.id);

    if (exists) {
      _account.recentlySearchedBooks.removeWhere((book) => book.id == bookSummary.id);
    }
    else if (_account.recentlySearchedBooks.length == 10) {
      _account.recentlySearchedBooks.removeFirst();
    }
    _account.recentlySearchedBooks.addLast(bookSummary);
    notifyListeners();

     // Save the book IDs to shared preferences
    List<String> bookIds = _account.recentlySearchedBooks.map((book) => book.id).toList();
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setStringList('recentBookIds', bookIds);
  }

  Future<ListQueue<BookSummary>> loadRecentsFromCache() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    List<String> recentBookIds = preferences.getStringList('recentBookIds') ?? [];
    if (recentBookIds.isEmpty) {
      return ListQueue<BookSummary>(10);
    }
    BookSummaryService bookSummaryService = BookSummaryService();
    List<BookSummary> recentBooks = [];
    for (String bookId in recentBookIds) {
      recentBooks.add(await bookSummaryService.getBookSummary(bookId));
    }
    BookImagesService bookImagesService = BookImagesService();
    List<String> recentBookImages = await bookImagesService.getBookImages(recentBookIds);
    for (int i = 0; i < recentBookIds.length; i++) {
      recentBooks[i].setImage(recentBookImages[i]);
    }
    return ListQueue<BookSummary>.from(recentBooks);
  }
}