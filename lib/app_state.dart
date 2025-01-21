import 'package:bookworms_app/models/child.dart';
import 'package:flutter/material.dart';


class AppState extends ChangeNotifier {
  final List<Child> _children = [Child(name: 'Johnny'), Child(name: 'Lily'), Child(name: 'Noah')];
  bool _isParent = false;

  List<Child> get children => _children;
  bool get isParent => _isParent;

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

  void setRole(String role) {
    _isParent = role == "Parent";
    notifyListeners();
  }
}