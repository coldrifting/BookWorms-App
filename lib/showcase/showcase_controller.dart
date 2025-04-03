import 'package:bookworms_app/app_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:showcaseview/showcaseview.dart';

class ShowcaseController {
  // Configure ShowcaseController as a singleton
  static final ShowcaseController _instance = ShowcaseController._internal();
  factory ShowcaseController() => _instance;
  ShowcaseController._internal();

  BuildContext? _rootContext;
  Function(int)? navigate;
  final Map<String, List<GlobalKey>> showcaseKeys = {};
  List<GlobalKey> showcaseKeysList = [];

  late final ShowCaseWidgetState _showcase = ShowCaseWidget.of(_rootContext!);

  static const Map<String, Map<String, int>> _elementsPerScreen = {
    'parent': {
      'home': 3,
      'bookshelves': 2,
      'search': 2,
      'progress': 2,
      'profile': 2,
      'navigation': 7 // 5 screens + beginning and ending cards
    },
    'teacher': {
      'home': 3,
      'search': 2,
      'classroom': 2,
      'profile': 2,
      'navigation': 7 // Same as parents, but #2 is unused. Easier to set up keys that way
    }
  };


  void setContext(BuildContext context) {
    _rootContext = context;
  }

  void initialize(Function(int) navFunction) {
    if (_rootContext == null) {
      throw StateError(
          "ShowcaseController context must be set before initializing state");
    }

    final appState = Provider.of<AppState>(_rootContext!, listen: false);
    navigate = navFunction;

    // these two statements have to be in this order
    _initializeKeys(appState.isParent);
    _initializeKeysList(appState.isParent);
  }

  void start() {
    if (showcaseKeysList == []) {
      throw StateError(
          "ShowcaseController state must have been initialized before starting showcase");
    }

    _showcase.startShowCase(showcaseKeysList);
  }

  void next() {
    _showcase.next();
  }

  void previous() {
    _showcase.previous();
  }

  void dismiss() {
    _showcase.dismiss();
  }

  List<GlobalKey> getKeysForScreen(String screenName) {
    return showcaseKeys[screenName] ?? [];
  }


  void _initializeKeys(bool isParent) {
    final numElements = isParent
        ? _elementsPerScreen['parent']!
        : _elementsPerScreen['teacher']!;
    final List<String> screens = numElements.keys.toList();

    // Initialize keys for each screen
    for (var screen in screens) {
      showcaseKeys[screen] = List.generate(
        numElements[screen]!,
        (_) => GlobalKey()
      );
    }

    // Initialize navigation keys
    showcaseKeys['navigation'] = List.generate(
        numElements['navigation']!,
        (_) => GlobalKey()
    );
  }

  void _initializeKeysList(bool isParent) {
    List<GlobalKey> navKeys = showcaseKeys['navigation']!;
    showcaseKeysList = (isParent
        ? [
            [navKeys[0]],
            [navKeys[1]],
            showcaseKeys['home']!,
            [navKeys[5]],
            showcaseKeys['profile']!,
            [navKeys[3]],
            showcaseKeys['search']!,
            [navKeys[2]],
            showcaseKeys['bookshelves']!,
            [navKeys[4]],
            showcaseKeys['progress']!,
            [navKeys[6]]
          ]
        : [
            [navKeys[0]],
            [navKeys[1]],
            showcaseKeys['home']!,
            [navKeys[5]],
            showcaseKeys['profile']!,
            [navKeys[3]],
            showcaseKeys['search']!,
            [navKeys[4]],
            showcaseKeys['classroom']!,
            [navKeys[6]]
          ]
    ).expand((element) => element).toList();
  }
}