import 'package:bookworms_app/models/account.dart';
import 'package:bookworms_app/models/account_details.dart';
import 'package:bookworms_app/models/child.dart';
import 'package:bookworms_app/models/parent_account.dart';
import 'package:bookworms_app/models/teacher_account.dart';
import 'package:bookworms_app/services/account/account_details_service.dart';
import 'package:flutter/material.dart';


class AppState extends ChangeNotifier {
  late Account _account;
  late bool _isParent;

  AppState() {
    tempLoadAccount();
  }

  void tempLoadAccount() {
    _account = Parent(
      username: "audHep",
      firstName: "Audrey",
      lastName: "Hepburn",
      profilePicture: "Icon1",
      recentlySearchedBooks: [],
      children: [Child(name: 'Johnny'), Child(name: 'Lily'), Child(name: 'Noah')],
      selectedChildID: 0
    );
    _isParent = _account is Parent;
  }

  Future<void> loadAccount() async {
    AccountDetailsService accountDetailsService = AccountDetailsService();
    AccountDetails accountDetails = await accountDetailsService.getAccountDetails();
    if (accountDetails.role == "Parent") {
      _account = Parent(
        username: accountDetails.username,
        firstName: accountDetails.firstName,
        lastName: accountDetails.lastName,
        profilePicture: accountDetails.icon,
        recentlySearchedBooks: [],
        children: [Child(name: 'Johnny'), Child(name: 'Lily'), Child(name: 'Noah')],
        selectedChildID: 0
      );
    } else {
      _account = Teacher(
        username: accountDetails.username,
        firstName: accountDetails.firstName,
        lastName: accountDetails.lastName,
        profilePicture: accountDetails.icon,
        recentlySearchedBooks: []
      );
    }
  }



  List<Child> get children => (_account as Parent).children;
  int get selectedChildID => (_account as Parent).selectedChildID;
  bool get isParent => _isParent;


  void addChild(Child child) {
    (_account as Parent).children.add(child);
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


  void setRole(String role) {
    _isParent = role == "Parent";
    notifyListeners();
  }
}