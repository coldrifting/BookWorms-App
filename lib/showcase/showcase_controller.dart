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
  late bool _isParent;
  final Map<String, List<GlobalKey>> _showcaseKeys = {};
  List<GlobalKey> _showcaseKeysList = [];
  late final ShowCaseWidgetState _showcase = ShowCaseWidget.of(_rootContext!);

  late Function(int) navigate;

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
      'home': 2,
      'search': 2,
      'classroom': 2,
      'profile': 2,
      'navigation': 6 // 4 screens + beginning and ending cards
    }
  };

  static const Map<String, Map<int, int>> _backNavigations = {
    'parent': {
      0: 0,
      1: 2,
      2: 4,
      3: 1,
      4: 0
    },
    'teacher': {
      0: 0,
      1: 3,
      2: 1,
      3: 0
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
    _isParent = appState.isParent;
    navigate = navFunction;

    // these two statements have to be in this order
    _initializeKeys(_isParent);
    _initializeKeysList(_isParent);
  }

  void start() {
    if (_showcaseKeysList == []) {
      throw StateError(
          "ShowcaseController state must have been initialized before starting showcase");
    }

    _showcase.startShowCase(_showcaseKeysList);
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
    return _showcaseKeys[screenName] ?? [];
  }

  int getScreenBefore(int screen) {
    return _backNavigations[_isParent? 'parent' : 'teacher']![screen]!;
  }


  void _initializeKeys(bool isParent) {
    final numElements = isParent
        ? _elementsPerScreen['parent']!
        : _elementsPerScreen['teacher']!;
    final List<String> screens = numElements.keys.toList();

    // Initialize keys for each screen
    for (var screen in screens) {
      _showcaseKeys[screen] = List.generate(
        numElements[screen]!,
        (_) => GlobalKey()
      );
    }

    // Initialize navigation keys
    _showcaseKeys['navigation'] = List.generate(
        numElements['navigation']!,
        (_) => GlobalKey()
    );
  }

  void _initializeKeysList(bool isParent) {
    List<GlobalKey> navKeys = _showcaseKeys['navigation']!;
    _showcaseKeysList = (isParent
        ? [
            [navKeys[0]],
            [navKeys[1]],
            _showcaseKeys['home']!,
            [navKeys[5]],
            _showcaseKeys['profile']!,
            [navKeys[3]],
            _showcaseKeys['search']!,
            [navKeys[2]],
            _showcaseKeys['bookshelves']!,
            [navKeys[4]],
            _showcaseKeys['progress']!,
            [navKeys[6]]
          ]
        : [
            [navKeys[0]],
            [navKeys[1]],
            _showcaseKeys['home']!,
            [navKeys[4]],
            _showcaseKeys['profile']!,
            [navKeys[2]],
            _showcaseKeys['search']!,
            [navKeys[3]],
            _showcaseKeys['classroom']!,
            [navKeys[5]]
          ]
    ).expand((element) => element).toList();
  }
}