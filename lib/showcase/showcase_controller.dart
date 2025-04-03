import 'package:bookworms_app/app_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:showcaseview/showcaseview.dart';

class ShowcaseController {
  // Configure ShowcaseController as a singleton
  static final ShowcaseController _instance = ShowcaseController._internal();
  factory ShowcaseController() => _instance;
  ShowcaseController._internal();

  ShowcaseState? _state;
  bool get _isInitialized => _state != null;
  ShowcaseState get _requireState {
    if (_state == null) {
      throw StateError("ShowcaseController must be initialized before use");
    }
    return _state!;
  }


  void initialize(BuildContext context, Function(int) navFunction) {
    // It's possible for initialize() to get invoked more than once,
    //  due to rebuilds. This protects state from being overwritten.
    if (_isInitialized) return;

    final appState = Provider.of<AppState>(context, listen: false);
    _state = ShowcaseState(
        context: context,
        isParent: appState.isParent,
        navFunction: navFunction
    );
  }

  void reset() {
    if (_state != null) {
      _state!.showcase.dismiss();
      _state = null;
    }
  }


  void start() {
    if (!_isInitialized) {
      throw StateError(
          "ShowcaseController state must have been initialized before starting showcase");
    }

    _requireState.showcase.startShowCase(_requireState.showcaseKeysList);
  }

  void next() => _requireState.showcase.next();

  void previous() => _requireState.showcase.previous();

  void dismiss() => _requireState.showcase.dismiss();

  void goToScreen(int index) => _requireState.navFunction(index);

  void skipToEnd() {
    _requireState.showcase.dismiss();
    _requireState.showcase.startShowCase([_requireState.showcaseKeysList.last]);
  }


  List<GlobalKey> getKeysForScreen(String screenName) {
    return _requireState.showcaseKeys[screenName] ?? [];
  }

  int getPreviousScreenIndex(int screenIndex) {
    return ShowcaseState.backNavigations[_requireState.isParent? 'parent' : 'teacher']![screenIndex]!;
  }
}

class ShowcaseState {
  final BuildContext context;
  final bool isParent;
  final Function(int) navFunction;
  final Map<String, List<GlobalKey>> showcaseKeys = {};
  late final List<GlobalKey> showcaseKeysList;
  late final ShowCaseWidgetState showcase;

  ShowcaseState({
    required this.context,
    required this.isParent,
    required this.navFunction
  }) {
    showcase = ShowCaseWidget.of(context);
    _initializeKeys();
    _initializeKeysList();
  }


  static const Map<String, Map<String, int>> _elementsPerScreen = {
    'parent': {
      'home': 3,
      'bookshelves': 2,
      'search': 2,
      'progress': 2,
      'profile': 3,
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

  static const Map<String, Map<int, int>> backNavigations = {
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


  void _initializeKeys() {
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

  void _initializeKeysList() {
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
          [navKeys[4]],
          showcaseKeys['profile']!,
          [navKeys[2]],
          showcaseKeys['search']!,
          [navKeys[3]],
          showcaseKeys['classroom']!,
          [navKeys[5]]
        ]
    ).expand((element) => element).toList();
  }
}