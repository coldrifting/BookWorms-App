import 'package:bookworms_app/models/child.dart';
import 'package:flutter/material.dart';


class AppState extends ChangeNotifier {
  final List<Child> _children = [Child(name: 'Johnny'), Child(name: 'Lily'), Child(name: 'Noah')];

  List<Child> get children => _children;

  void addChild(Child child) {
    _children.add(child);
    notifyListeners();
  }
}