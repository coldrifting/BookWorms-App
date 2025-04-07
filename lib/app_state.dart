import 'dart:collection';
import 'package:bookworms_app/models/Result.dart';
import 'package:bookworms_app/models/classroom/announcement.dart';
import 'package:bookworms_app/models/classroom/classroom.dart';
import 'package:bookworms_app/models/goals/child_goal.dart';
import 'package:bookworms_app/models/goals/classroom_goal.dart';
import 'package:bookworms_app/models/goals/goal.dart';
import 'package:bookworms_app/resources/colors.dart';
import 'package:bookworms_app/resources/constants.dart';
import 'package:bookworms_app/services/account/child_goal_services.dart';
import 'package:bookworms_app/services/account/children_services.dart';
import 'package:bookworms_app/services/book/bookshelf_service.dart';
import 'package:bookworms_app/services/classroom/classroom_goals_service.dart';
import 'package:bookworms_app/services/classroom/classroom_service.dart';
import 'package:bookworms_app/utils/user_icons.dart';
import 'package:collection/collection.dart';
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
        setChildGoals(i);
      }
    } else {
      setClassroomDetails();
    }
  }

  List<Child> get children => (_account as Parent).children;
  int get selectedChildID => (_account as Parent).selectedChildID;

  Future<Result> addChild(String childName) async {
    ChildrenServices childrenServices = ChildrenServices();
    try {
      Child newChild = await childrenServices.addChild(childName);
      (_account as Parent).children.add(newChild);
      setChildBookshelves(children.length - 1);
      setChildClassrooms(children.length - 1);
      newChild.profilePictureIndex = UserIcons.getRandomIconIndex();
      await childrenServices.setAccountDetails(newChild, iconIndex: newChild.profilePictureIndex);
      notifyListeners();
      return Result(isSuccess: true, message: "Successfully added the child profile.");
    } catch (_) {
      return Result(isSuccess: false, message: "Failed to add the child profile.");
    }
  }

  Future<Result> removeChild(String childId) async {
    ChildrenServices childrenServices = ChildrenServices();
    try {
      await childrenServices.removeChild(childId);
      (_account as Parent).children.removeWhere((c) => c.id == childId);
      notifyListeners();
      return Result(isSuccess: true, message: "Successfully deleted the child profile.");
    } catch (_) {
      return Result(isSuccess: false, message: "Failed to delete the child profile.");
    }
  }

  void setSelectedChild(int childID) {
    (_account as Parent).selectedChildID = childID;
    notifyListeners();
  }

  void editChildProfileInfo(int childId, {String? newName, int? profilePictureIndex, String? newDOB}) async {
    Child child = (_account as Parent).children[childId];
    // If not included as parameters, set to currently-saved value.
    newName ??= child.name;
    profilePictureIndex ??= child.profilePictureIndex;
    newDOB ??= child.dob;

    ChildrenServices childrenServices = ChildrenServices();
    childrenServices.setAccountDetails(child, newName: newName, iconIndex: profilePictureIndex, newDOB: newDOB);

    child.name = newName;
    child.profilePictureIndex = profilePictureIndex;
    child.dob = newDOB;
    notifyListeners();
  }

  void setChildClassrooms(int childId) async {
    ChildrenServices childrenServices = ChildrenServices();
    String guid = children[childId].id;
    List<Classroom> classrooms = await childrenServices.setChildClassrooms(guid);
    (_account as Parent).children[childId].classrooms = classrooms;
    notifyListeners();
  }

  Future<Result> joinChildClassroom(int childId, String classCode) async {
    ChildrenServices childrenServices = ChildrenServices();
    String guid = children[childId].id;

    if (children[childId].classrooms.firstWhereOrNull((c) => c.classCode.toLowerCase() == classCode.toLowerCase()) != null) {
      return Result(isSuccess: false, message: "Already a part of this class");
    }

    try {
      Classroom? newClassroom = await childrenServices.joinChildClassroom(guid, classCode);

      if (newClassroom != null) {
        (_account as Parent).children[childId].classrooms.add(newClassroom);
        setChildBookshelves(childId); // Reset the child's bookshelves.
        notifyListeners();
        return Result(isSuccess: true, message: "Successfully joined the classroom.");
      }
    } catch (_) {
      return Result(isSuccess: false, message: "Failed to join the classroom.");
    }
    return Result(isSuccess: false, message: "This classroom does not exist.");
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

  Future<Bookshelf> getRecommendedAuthorsBookshelf([int? childId]) async {
    String? guid;
    if (childId != null) {
      guid = children[childId].id;
    }

    List<BookSummary> bookDetails = await bookshelvesService.getRecommendedAuthorsBookshelf(guid);
    Bookshelf bookshelf = Bookshelf(books: bookDetails, type: BookshelfType.recommended, name: "Recommended Authors");
    _setBookImages([bookshelf]);
    return bookshelf;
  }

  Future<Bookshelf> getRecommendedDescriptionsBookshelf([int? childId]) async {
    String? guid;
    if (childId != null) {
      guid = children[childId].id;
    }
    List<BookSummary> bookDetails = await bookshelvesService.getRecommendedDescriptionBookshelf(guid);
    Bookshelf bookshelf = Bookshelf(books: bookDetails, type: BookshelfType.recommended, name: "Recommended Books");
    _setBookImages([bookshelf]);
    return bookshelf;
  }

  Future<Result> addChildBookshelf(int childId, Bookshelf bookshelf) async {
    String guid = children[childId].id;
    try {
      await bookshelvesService.addBookshelf(guid, bookshelf.name);
      (_account as Parent).children[childId].bookshelves.add(bookshelf);
      _setBookImages([bookshelf]);
      notifyListeners();
      return Result(isSuccess: true, message: "Successfully added the new bookshelf.");
    } catch (_) {
      return Result(isSuccess: false, message: "Failed to add the new bookshelf.");
    }
  }

  Future<Result> addChildBookshelfWithBook(int childId, Bookshelf bookshelf) async {
    String guid = children[childId].id;
    try {
      await bookshelvesService.addBookshelf(guid, bookshelf.name);
      await bookshelvesService.addBookToBookshelf(guid, bookshelf.name, bookshelf.books[0].id);
      (_account as Parent).children[childId].bookshelves.add(bookshelf);
      _setBookImages([bookshelf]);
      notifyListeners();
      return Result(isSuccess: true, message: "Successfully added the book to the new bookshelf.");
    } catch (_) {
      return Result(isSuccess: false, message: "Failed to add the new book to the bookshelf.");
    }
  }

  Future<Result> renameChildBookshelf(int childId, Bookshelf bookshelf, String newName) async {
    String guid = children[childId].id;
    try {
      await bookshelvesService.renameBookshelfService(guid, bookshelf.name, newName);
      (_account as Parent).children[childId].bookshelves
          .firstWhere((b) => b.name == bookshelf.name && b.type == BookshelfType.custom).name = newName;
          notifyListeners();
      return Result(isSuccess: true, message: "Successfully renamed the bookshelf.");
    } catch (_) {
      return Result(isSuccess: false, message: "Failed to rename the bookshelf.");
    }
  }

  Future<Result> deleteChildBookshelf(int childId, Bookshelf bookshelf) async {
    String guid = children[childId].id;
    try {
      await bookshelvesService.deleteBookshelf(guid, bookshelf.name);
      (_account as Parent).children[childId].bookshelves
          .removeWhere((b) => b.name == bookshelf.name && b.type == BookshelfType.custom);
      notifyListeners();
      return Result(isSuccess: true, message: "Successfully deleted the bookshelf.");
    } catch (_) {
      return Result(isSuccess: false, message: "Failed to delete the bookshelf.");
    }
  }

  Future<Result> removeBookFromBookshelf(int childId, Bookshelf bookshelf, String bookId) async {
    String guid = children[childId].id;
    int index = bookshelves.indexWhere((b) => b.name == bookshelf.name);
    
    try {
      // Remove the book server-side.
      await bookshelvesService.removeBookFromBookshelf(guid, bookshelf.name, bookId);
      
      if (index != -1) {
        (_account as Parent).children[childId].bookshelves[index].books.removeWhere((b) => b.id == bookId);
        _setBookImages([bookshelf]);
        notifyListeners();
        return Result(isSuccess: true, message: "Successfully deleted the book.");
      }
    } catch (_) {
      return Result(isSuccess: false, message: "Failed to delete the book.");
    }
    return Result(isSuccess: false, message: "This book does not exist in ${bookshelf.name}.");
  }

  Future<Result> addBookToBookshelf(int childId, Bookshelf bookshelf, BookSummary book) async {
    BookImagesService bookImagesService = BookImagesService();

    String guid = children[childId].id;
    int index = bookshelves.indexWhere((b) => b.name == bookshelf.name);
    
    if (!bookshelves[index].books.any((b) => b.id == book.id)) {
      // Add the book server-side.
      try {
        await bookshelvesService.addBookToBookshelf(guid, bookshelf.name, book.id);
        if (index != -1) {
          (_account as Parent).children[childId].bookshelves[index].books.add(book);
          var bookIds = await bookImagesService.getBookImages([book.id]);
          book.imageUrl = bookIds[0];
          notifyListeners();
        }
        return Result(isSuccess: true, message: "Successfully added the book to the bookshelf.");
      } catch (_) {
        return Result(isSuccess: false, message: "Failed to add the book to the bookshelf.");
      }
    }
    return Result(isSuccess: false, message: "This book is already in ${bookshelf.name}.", color: colorGreyDark);
  }


  // ***** Classroom *****

  ClassroomService classroomService = ClassroomService();
  Classroom? get classroom => (_account as Teacher).classroom;

  void setClassroomDetails() async {
    Classroom? classroom = await classroomService.getClassroomDetails();
    (_account as Teacher).classroom = classroom;
    if (classroom != null) {
      _setBookImages(classroom.bookshelves);
      classroom.classroomGoals = await getClassroomGoals();
    }
    notifyListeners();
  }

  Future<Result> createNewClassroom(String newClassroomName) async {
    try {
      Classroom classroom = await classroomService.createClassroomDetails(newClassroomName);
      (_account as Teacher).classroom = classroom;
      notifyListeners();
      return Result(isSuccess: true, message: "Successfully created the classroom.");
    } catch (_) {
      return Result(isSuccess: false, message: "Failed to create the classroom.");
    }
  }

  Future<Result> changeClassroomIcon(int newIcon) async {
    try {
      await classroomService.changeClassroomIcon(newIcon);
      classroom!.classIcon = newIcon;
      notifyListeners();
      return Result(isSuccess: true, message: "Successfully changed the classroom icon.");
    } catch (_) {
      return Result(isSuccess: false, message: "Failed to change the classroom icon.");
    }
    
  }

  Future<Result> deleteClassroom() async {
    try {
      await classroomService.deleteClassroom();
      (_account as Teacher).classroom = null;
      notifyListeners();
      return Result(isSuccess: true, message: "Successfully deleted the classroom.");
    } catch (_) {
      return Result(isSuccess: false, message: "Failed to delete the classroom.");
    }
  }

  Future<Result> renameClassroom(String newName) async {
    try {
      await classroomService.changeClassroomName(newName);
      classroom!.classroomName = newName;
      notifyListeners();
      return Result(isSuccess: true, message: "Successfully renamed the classroom.");
    } catch (_) {
      return Result(isSuccess: false, message: "Failed to rename the classroom.");
    }
  }

  Future<Result> renameClassroomBookshelf(String oldName, String newName) async {
    try {
      await classroomService.renameClassroomBookshelf(oldName, newName);
        for (var bookshelf in classroom!.bookshelves) {
          if (bookshelf.name == oldName) {
            bookshelf.name = newName;
            break;
          }
        }
      notifyListeners();
      return Result(isSuccess: true, message: "Successfully renamed the bookshelf.");
    } catch (_) {
      return Result(isSuccess: false, message: "Failed to rename the bookshelf.");
    }
  }

  Future<Result> createClassroomBookshelf(Bookshelf bookshelf) async {
    try {
      await classroomService.createClassroomBookshelf(bookshelf);
      classroom!.bookshelves.add(bookshelf);
      notifyListeners();
      return Result(isSuccess: true, message: "Successfully created the bookshelf.");
    } catch (_) {
      return Result(isSuccess: false, message: "Failed to create the bookshelf.");
    }
  }

  Future<Result> createClassroomBookshelfWithBook(Bookshelf bookshelf) async {
    try {
      await classroomService.createClassroomBookshelf(bookshelf);
      classroom!.bookshelves.add(bookshelf);
      await classroomService.insertBookIntoClassroomBookshelf(bookshelf, bookshelf.books[0]);
      notifyListeners();
      return Result(isSuccess: true, message: "Successfully added the book to the new bookshelf.");
    }
    catch (_) {
      return Result(isSuccess: false, message: "Failed to add the book to the new bookshelf.");
    }
  }

  Future<Result> deleteClassroomBookshelf(Bookshelf bookshelf) async {
    try {
      await classroomService.deleteClassroomBookshelf(bookshelf);
      classroom!.bookshelves.remove(bookshelf);
      notifyListeners();
      return Result(isSuccess: true, message: "Successfully deleted the classroom bookshelf.");
    } catch (_) {
      return Result(isSuccess: false, message: "Failed to delete the classroom bookshelf.");
    }
  }

  Future<Result> addBookToClassroomBookshelf(Bookshelf bookshelf, BookSummary book) async {
    BookImagesService bookImagesService = BookImagesService();

    int index = bookshelves.indexWhere((b) => b.name == bookshelf.name);
    if (!bookshelves[index].books.any((b) => b.id == book.id)) {
      try {
        // Add the book server-side.
        await classroomService.insertBookIntoClassroomBookshelf(bookshelf, book);
        
        if (index != -1) {
          bookshelves[index].books.add(book);
          var bookIds = await bookImagesService.getBookImages([book.id]);
          book.imageUrl = bookIds[0];
          notifyListeners();
          return Result(isSuccess: true, message: "Successfully added the book to the bookshelf.");
        }
      } catch (_) {
        return Result(isSuccess: false, message: "Failed to add the book to the bookshelf.");
      }
    }
    return Result(isSuccess: false, message: "This book already exists in the bookshelf.", color: colorGreyDark);
  }

  Future<Result> removeBookFromClassroomBookshelf(Bookshelf bookshelf, BookSummary book) async {
    int index = bookshelves.indexWhere((b) => b.name == bookshelf.name);
    
    // Remove the book server-side.
    try {
      await classroomService.removeBookFromClassroomBookshelf(bookshelf, book);
      
      if (index != -1) {
        bookshelves[index].books.removeWhere((b) => b.id == book.id);
        _setBookImages([bookshelf]);
        notifyListeners();
        return Result(isSuccess: true, message: "Successfully deleted the book from the bookshelf.");
      }
    } catch (_) {
      return Result(isSuccess: false, message: "Failed to delete the book from the bookshelf.");
    }
    return Result(isSuccess: false, message: "This book does not exist in the bookshelf.", color: colorGreyDark);
  }

  Future<Result> deleteStudentFromClassroom(String studentId) async {
    try {
      await classroomService.deleteStudentFromClassroom(studentId);
      classroom!.students.removeWhere((s) => s.id == studentId);
      notifyListeners();
      return Result(isSuccess: true, message: "Successfully deleted the student from the classroom.");
    } catch (_) {
      return Result(isSuccess: false, message: "Failed to delete the student from the classroom.");
    }
  }


  // ***** Classroom Goals - Teacher *****

  ClassroomGoalsService classroomGoalsService = ClassroomGoalsService();
  List<dynamic>? get goals => isParent 
    ? children[selectedChildID].goals 
    : classroom!.classroomGoals;

  Future<List<ClassroomGoal>> getClassroomGoals() async {
    return await classroomGoalsService.getClassroomGoals();
  }

  Future<Result> addClassroomGoal(Goal goal) async {
    try {
      ClassroomGoal newGoal = await classroomGoalsService.addClassroomGoal(goal);
      (_account as Teacher).classroom!.classroomGoals.add(newGoal);
      notifyListeners();
      
      return Result(isSuccess: true, message: "Successfully added the classroom goal.");
    } catch (_) {
      return Result(isSuccess: false, message: "Failed to create the classroom goal");
    }
  }

  Future<ClassroomGoal> getBasicClassroomGoalDetails(String goalId) async {
    ClassroomGoal goal = await classroomGoalsService.getClassroomGoalDetails(goalId, false);
    return goal;
  }

  Future<ClassroomGoal> getDetailedClassroomGoalDetails(String goalId) async {
    ClassroomGoal goal = await classroomGoalsService.getClassroomGoalDetails(goalId, true);
    return goal;
  }

  Future<ClassroomGoal> editClassroomGoal(String goalId, {String? newTitle, String? newEndDate, int? newTargetNumBooks}) async {
    ClassroomGoal goal = await classroomGoalsService.editClassroomGoal(goalId, newTitle, newEndDate, newTargetNumBooks);
    int index = classroom!.classroomGoals.indexWhere((g) => g.goalId == goalId);
    if (index != -1) {
      classroom!.classroomGoals[index] = goal;
      notifyListeners();
    }
    return goal;
  }

  Future<Result> deleteClassroomGoal(goalId) async {
    try {
      await classroomGoalsService.deleteClassroomGoal(goalId);
      classroom!.classroomGoals.removeWhere((g) => g.goalId == goalId);
      notifyListeners();
      return Result(isSuccess: true, message: "Successfully deleted the classroom.");
    } catch (_) {
      return Result(isSuccess: false, message: "Failed to delete the classroom.");
    }
  }

  // ***** Child Goals *****

  ChildGoalService childGoalService = ChildGoalService();

  Future<void> setChildGoals(int childId) async {
    Child child = children[childId];
    List<ChildGoal> goals = await childGoalService.getChildGoals(child.id);
    child.goals = goals;
    notifyListeners();
  }

  Future<Result> addChildGoal(Child child, Goal goal) async {
    try {
      ChildGoal childGoal = await childGoalService.addChildGoal(goal, child.id);
      child.goals.add(childGoal);
      notifyListeners();
      return Result(isSuccess: true, message: "Successfully created the new goal.");
    } catch (_) {
      return Result(isSuccess: false, message: "Failed to create the new goal.");
    }
  }

  Future<ChildGoal> getChildGoalDetails(Child child, String goalId) async {
    ChildGoal childGoal = await childGoalService.getChildGoalDetails(child.id, goalId);
    return childGoal;
  }

  Future<bool> logChildGoalProgress(Child child, String goalId, int progress) async {
    try {
      await childGoalService.logChildGoal(child.id, goalId, progress);
      int index = child.goals.indexWhere((g) => g.goalId == goalId);
      child.goals[index].progress = progress;
      notifyListeners();
      return true;
    } catch (_) {
      return false;
    }
    
  }

  Future<Result> editChildGoal(Child child, String goalId, String title, String startDate, String dueDate, int progress) async {
    try {
      ChildGoal childGoal = await childGoalService.editChildGoal(child.id, goalId, title, startDate, dueDate);
      int index = child.goals.indexWhere((g) => g.goalId == goalId);
      bool success = await logChildGoalProgress(child, goalId, progress);
      if (success) {
        childGoal.progress = progress;
        child.goals[index] = childGoal;
        notifyListeners();
        return Result(isSuccess: true, message: "Successfully edited the goal.");
      }
    } catch (_) {
      return Result(isSuccess: false, message: "Failed to edit the goal.");
    }
    return Result(isSuccess: false, message: "Failed to log the goal progress.");
  }

  Future<Result> deleteChildGoal(Child child, String goalId) async {
    try {
      await childGoalService.deleteChildGoal(child.id, goalId);
      child.goals.removeWhere((g) => g.goalId == goalId);
      notifyListeners();
      return Result(isSuccess: true, message: "Successfully deleted the goal.");
    } catch (_) {
      return Result(isSuccess: false, message: "Failed to delete the goal.");
    }
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

  Future<bool> addAnnouncement(String title, String body) async {
    Announcement? result = await classroomService.addAnnouncement(title, body);
    if (result != null) {
      classroom!.announcements.add(result);
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<bool> editAnnouncement(String announcementId, String title, String body) async {
    bool result = await classroomService.editAnnouncement(announcementId, title, body);
    if (result) {
      Announcement announcement = classroom!.announcements
          .firstWhere((a) => a.announcementId == announcementId);

      announcement.title = title;
      announcement.body = body;

      notifyListeners();
    }
    return result;
  }

  Future<bool> deleteAnnouncement(String announcementId) async {
    bool result = await classroomService.deleteAnnouncement(announcementId);
    if (result) {
      classroom!.announcements
          .removeWhere((a) => a.announcementId == announcementId);

      notifyListeners();
    }
    return result;
  }

  Future<bool> markAnnouncementAsRead(Announcement announcement) async {
    String childId = (account as Parent).children[selectedChildID].id;
    Announcement announce = (account as Parent).children[selectedChildID].classrooms
        .expand((a) => a.announcements)
        .firstWhere((a) => a.announcementId == announcement.announcementId);

    bool result = await classroomService.markAnnouncementRead(announcement.announcementId, childId);
    if (result) {
      announce.isRead = true;
      notifyListeners();
    }
    return result;
  }


  // ***** Showcase *****

  Future<bool> isFirstLaunch() async {
    final String isFirstLaunchKey = 'is_first_launch_$username';
    SharedPreferences preferences = await SharedPreferences.getInstance();
    bool isFirstLaunch = preferences.getBool(isFirstLaunchKey) ?? true;

    if (isFirstLaunch) {
      await preferences.setBool(isFirstLaunchKey, false);
    }

    return isFirstLaunch;
  }

}