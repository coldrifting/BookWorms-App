import 'package:bookworms_app/models/account.dart';
import 'package:bookworms_app/models/child.dart';
import 'package:flutter/material.dart';

class AppState extends ChangeNotifier {
  final Account _account = Account(username: "audHep", firstName: "Audrey", lastName: "Hepburn");
  Account get account => _account;

  bool _isParent = true;
  bool get isParent => _isParent;

  final List<Child> _children = [Child(name: 'Johnny', iconIndex: 0), Child(name: 'Lily', iconIndex: 1), Child(name: 'Noah', iconIndex: 2)];
  int _selectedChildID = 0;
  List<Child> get children => _children;
  int get selectedChild => _selectedChildID;

  // Account-specific
  void setRole(String role) {
    _isParent = role == "Parent";
    notifyListeners();
  }

  void editFirstName(String firstName) {
    _account.firstName = firstName;
    notifyListeners();
  }

  void editLastName(String lastName) {
    _account.lastName = lastName;
    notifyListeners();
  }

  void editUsername(String username) {
    _account.username = username;
    notifyListeners();
  }

  // Child-specific
  void addChild(Child child) {
    _children.add(child);
    notifyListeners();
  }

  void removeChild(int childID) {
    _children.removeAt(childID);
    notifyListeners();
  }
  
  void editChildName(int childID, String newName) {
    _children[childID].name = newName;
    notifyListeners();
  }

  void setSelectedChild(int childID) {
    _selectedChildID = childID;
    notifyListeners();
  }

  void setChildIconIndex(int childId, int index) {
    _children[childId].iconIndex = index;
    notifyListeners();
  }

}