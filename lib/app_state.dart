import 'dart:collection';
import 'package:bookworms_app/models/classroom/classroom.dart';
import 'package:bookworms_app/models/goals/classroom_goal.dart';
import 'package:bookworms_app/services/account/children_services.dart';
import 'package:bookworms_app/services/book/bookshelf_service.dart';
import 'package:bookworms_app/services/classroom/classroom_goals_service.dart';
import 'package:bookworms_app/services/classroom/classroom_service.dart';
import 'package:bookworms_app/utils/user_icons.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bookworms_app/models/account/account.dart';
import 'package:bookworms_app/models/account/account_details.dart';
import 'package:bookworms_app/models/book/book_summary.dart';
import 'package:bookworms_app/models/book/bookshelf.dart';
import 'package:bookworms_app/models/child/child.dart';
import 'package:bookworms_app/models/account/parent_account.dart';
import 'package:bookworms_app/models/account/teacher_account.dart';
import 'package:bookworms_app/services/account/account_details_service.dart';
import 'package:bookworms_app/services/account/account_details_edit_service.dart';
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

  // Loads account details according to the account's role.
  Future<void> loadAccountSpecifics() async {
    if (_isParent) {
      ChildrenServices childrenServices = ChildrenServices();
      List<Child> children = await childrenServices.getChildren();
      (_account as Parent).children = children;
      for (var i = 0; i < children.length; i++) {
        setChildBookshelves(i);
        setChildClassrooms(i);
      }
    } else {
      getClassroomDetails();
    }
  }

  List<Child> get children => (_account as Parent).children;
  int get selectedChildID => (_account as Parent).selectedChildID;

  Future<void> addChild(String childName) async {
    ChildrenServices childrenServices = ChildrenServices();
    Child newChild = await childrenServices.addChild(childName);
    (_account as Parent).children.add(newChild);
    setChildBookshelves(children.length - 1);
    setChildClassrooms(children.length - 1);
    newChild.profilePictureIndex = UserIcons.getRandomIconIndex();
    notifyListeners();
  }

  void removeChild(int childID) {
    (_account as Parent).children.removeAt(childID);
    notifyListeners();
  }

  void setSelectedChild(int childID) {
    (_account as Parent).selectedChildID = childID;
    notifyListeners();
  }

   void editChildProfileInfo(int childId, {String? newName, int? profilePictureIndex}) async {
    Child child = (_account as Parent).children[childId];
    // If not included as parameters, set to currently-saved value.
    newName ??= child.name;
    profilePictureIndex ??= child.profilePictureIndex;

    ChildrenServices childrenServices = ChildrenServices();
    childrenServices.setAccountDetails(child, newName: newName, iconIndex: profilePictureIndex);

    child.name = newName;
    child.profilePictureIndex = profilePictureIndex;
    notifyListeners();
  }

  void setChildClassrooms(int childId) async {
    ChildrenServices childrenServices = ChildrenServices();
    String guid = children[childId].id;
    List<Classroom> classrooms = await childrenServices.setChildClassrooms(guid);
    (_account as Parent).children[childId].classrooms = classrooms;
    notifyListeners();
  }

  void joinChildClassroom(int childId, String classCode) async {
    ChildrenServices childrenServices = ChildrenServices();
    String guid = children[childId].id;
    Classroom newClassroom = await childrenServices.joinChildClassroom(guid, classCode);
    (_account as Parent).children[childId].classrooms.add(newClassroom);
    setChildBookshelves(childId); // Reset the child's bookshelves.
    notifyListeners();
  }

  // ***** Bookshelves *****

  BookshelfService bookshelvesService = BookshelfService();
  List<Bookshelf> get bookshelves => isParent 
    ? (_account as Parent).children[selectedChildID].bookshelves 
    : (_account as Teacher).classroom != null 
      ? (_account as Teacher).classroom!.bookshelves 
      : [];

  void setChildBookshelves(int childId) async {
    String guid = children[childId].id;
    List<Bookshelf> bookshelves = await bookshelvesService.getBookshelves(guid);
    (_account as Parent).children[childId].bookshelves = bookshelves;
    _setBookImages(bookshelves);
    notifyListeners();
  }

  Future<Bookshelf> getChildBookshelf(int childId, int bookshelfIndex) async {
    String guid = children[childId].id;
    Bookshelf bookshelf = children[selectedChildID].bookshelves[bookshelfIndex];
    Bookshelf fullBookshelf = await bookshelvesService.getBookshelf(guid, bookshelf);
    _setBookImages([fullBookshelf]);
    return fullBookshelf;
  }

  Future<Bookshelf> getRecommendedAuthorsBookshelf(int childId) async {
    String guid = children[childId].id;
    Bookshelf bookshelf = await bookshelvesService.getRecommendedAuthorsBookshelf(guid);
    _setBookImages([bookshelf]);
    return bookshelf;
  }

  Future<Bookshelf> getRecommendedDescriptionsBookshelf(int childId) async {
    String guid = children[childId].id;
    Bookshelf bookshelf = await bookshelvesService.getRecommendedDescriptionBookshelf(guid);
    _setBookImages([bookshelf]);
    return bookshelf;
  }

  void addChildBookshelf(int childId, Bookshelf bookshelf) async {
    String guid = children[childId].id;
    var success = await bookshelvesService.addBookshelf(guid, bookshelf.name);
    if (success) {
      (_account as Parent).children[childId].bookshelves.add(bookshelf);
      _setBookImages([bookshelf]);
      notifyListeners();
    }
  }

  void renameChildBookshelf(int childId, Bookshelf bookshelf, String newName) async {
    String guid = children[childId].id;
    var success = await bookshelvesService.renameBookshelfService(guid, bookshelf.name, newName);
    
    if (success) {
      for (var shelf in (_account as Parent).children[childId].bookshelves) {
        if (shelf.name == bookshelf.name) {
          bookshelf.name = newName;
          break;
        }
      }
      notifyListeners();
    }
  }

  void deleteChildBookshelf(int childId, Bookshelf bookshelf) async {
    String guid = children[childId].id;
    var success = await bookshelvesService.deleteBookshelf(guid, bookshelf.name);
    if (success) {
      (_account as Parent).children[childId].bookshelves.removeWhere((b) => b.name == bookshelf.name);
      notifyListeners();
    }
  }

  void removeBookFromBookshelf(int childId, Bookshelf bookshelf, String bookId) async {
    String guid = children[childId].id;
    int index = bookshelves.indexWhere((b) => b.name == bookshelf.name);
    
    // Remove the book server-side.
    var success = await bookshelvesService.removeBookFromBookshelf(guid, bookshelf.name, bookId);
    
    if (index != -1 && success) {
      (_account as Parent).children[childId].bookshelves[index].books.removeWhere((b) => b.id == bookId);
      _setBookImages([bookshelf]);
      notifyListeners();
    }
  }

  Future<bool> addBookToBookshelf(int childId, Bookshelf bookshelf, BookSummary book) async {
    BookImagesService bookImagesService = BookImagesService();

    String guid = children[childId].id;
    int index = bookshelves.indexWhere((b) => b.name == bookshelf.name);
    
    if (!bookshelves[index].books.any((b) => b.id == book.id)) {
      // Add the book server-side.
      var success = await bookshelvesService.addBookToBookshelf(guid, bookshelf.name, book.id);
      
      if (index != -1 && success) {
        (_account as Parent).children[childId].bookshelves[index].books.add(book);
        var bookIds = await bookImagesService.getBookImages([book.id]);
        book.imageUrl = bookIds[0];
        notifyListeners();
        return true;
      }
    }
    return false;
  }


  // ***** Classroom *****

  ClassroomService classroomService = ClassroomService();
  Classroom? get classroom => (_account as Teacher).classroom;

  void getClassroomDetails() async {
    Classroom? classroom = await classroomService.getClassroomDetails();
    (_account as Teacher).classroom = classroom;
    if (classroom != null) {
      _setBookImages(classroom.bookshelves);
    }
    notifyListeners();
  }

  Future<Classroom> createNewClassroom(String newClassroomName) async {
    Classroom classroom = await classroomService.createClassroomDetails(newClassroomName);
    (_account as Teacher).classroom = classroom;
    notifyListeners();
    return classroom;
  }

  Future<bool> deleteClassroom() async {
    var success = await classroomService.deleteClassroom();
    (_account as Teacher).classroom = null;
    notifyListeners();
    return success;
  }

  void createClassroomBookshelf(Bookshelf bookshelf) async {
    var success = await classroomService.createClassroomBookshelf(bookshelf);
    if (success) {
      (_account as Teacher).classroom!.bookshelves.add(bookshelf);
      notifyListeners();
    }
  }

  void deleteClassroomBookshelf(Bookshelf bookshelf) async {
    var success = await classroomService.deleteClassroomBookshelf(bookshelf);
    if (success) {
      (_account as Teacher).classroom!.bookshelves.remove(bookshelf);
      notifyListeners();
    }
  }

  Future<bool> addBookToClassroomBookshelf(Bookshelf bookshelf, BookSummary book) async {
    BookImagesService bookImagesService = BookImagesService();

    int index = bookshelves.indexWhere((b) => b.name == bookshelf.name);
    
    if (!bookshelves[index].books.any((b) => b.id == book.id)) {
      // Add the book server-side.
      var success = await classroomService.insertBookIntoClassroomBookshelf(bookshelf, book);
      
      if (index != -1 && success) {
        bookshelves[index].books.add(book);
        var bookIds = await bookImagesService.getBookImages([book.id]);
        book.imageUrl = bookIds[0];
        notifyListeners();
        return true;
      }
    }
    return false;
  }

  void removeBookFromClassroomBookshelf(Bookshelf bookshelf, BookSummary book) async {
    int index = bookshelves.indexWhere((b) => b.name == bookshelf.name);
    
    // Remove the book server-side.
    var success = await classroomService.removeBookFromClassroomBookshelf(bookshelf, book);
    
    if (index != -1 && success) {
      bookshelves[index].books.removeWhere((b) => b.id == book.id);
      _setBookImages([bookshelf]);
      notifyListeners();
    }
  }


  // ***** Classroom Goals - Teacher *****

  ClassroomGoalsService classroomGoalsService = ClassroomGoalsService();
  List<ClassroomGoal>? get classroomGoals => (_account as Teacher).classroom?.classroomGoals;


  void getClassroomGoals() async {
    List<ClassroomGoal> goals = await classroomGoalsService.getClassroomGoals();
    (_account as Teacher).classroom?.classroomGoals = goals;
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
      recentBooks[i].imageUrl = recentBookImages[i];
    }
    return ListQueue<BookSummary>.from(recentBooks);
  }

  void _setBookImages(List<Bookshelf> bookshelves) async {
    BookImagesService bookImagesService = BookImagesService();

    final bookIds = bookshelves
      .expand((bookshelf) => bookshelf.books.map((book) => book.id))
      .toList();

    if (bookIds.isNotEmpty) {
      List<String> bookImages = await bookImagesService.getBookImages(bookIds);

      int count = 0;
      for (var bookshelf in bookshelves) {
        for (var book in bookshelf.books) {
          if (count < bookImages.length) {
            book.imageUrl = bookImages[count];
            count++;
          } else {
            break;
          }
        }
      }
    }
  }
}