import 'package:bookworms_app/models/child.dart';
import 'package:flutter/material.dart';


class AppState extends ChangeNotifier {
  final List<Child> _children = [Child(name: 'Johnny'), Child(name: 'Lily'), Child(name: 'Noah')];

  List<Child> get children => _children;

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
}