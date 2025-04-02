import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bookworms_app/app_state.dart';
import 'package:bookworms_app/screens/bookshelves/bookshelves_screen.dart';
import 'package:bookworms_app/screens/classroom/classroom_screen.dart';
import 'package:bookworms_app/screens/home_screen.dart';
import 'package:bookworms_app/screens/profile/profile_screen.dart';
import 'package:bookworms_app/screens/progress_screen.dart';
import 'package:bookworms_app/resources/colors.dart';
import 'package:bookworms_app/resources/theme.dart';
import 'package:bookworms_app/screens/search/search_screen.dart';
import 'package:bookworms_app/screens/setup/splash_screen.dart';

void main() => runApp(const BookWorms());

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

// Store nav keys for sub navigation
final Map<int, GlobalKey<NavigatorState>> navKeys = {};

final GlobalKey<SearchScreenState> searchKey = GlobalKey<SearchScreenState>();

/// Bookworms is a virtual book search solution for children's books.
/// It allows for the saving of books to bookshelves, the tracking of
/// a child's goals, and creating classrooms to assign readings to students.
class BookWorms extends StatelessWidget {
  const BookWorms({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AppState>(
        create: (context) => AppState(),
        child: MaterialApp(
            navigatorKey: navigatorKey,
            title: 'BookWorms',
            theme: appTheme,
            home: const SplashScreen(),
            scrollBehavior: const ScrollBehavior().copyWith(dragDevices: {
              PointerDeviceKind.touch,
              PointerDeviceKind.mouse,
              PointerDeviceKind.stylus,
              PointerDeviceKind.trackpad,
            })));
  }
}

/// The [Navigation] deals with the main bottom bar navigation between the
/// "Home", "Bookshelves", "Search", "Progress", and "Profile" screens.
class Navigation extends StatefulWidget {
  final int initialIndex;

  const Navigation({super.key, this.initialIndex = 0});

  @override
  State<Navigation> createState() => _Navigation();
}

/// The state of the [Navigation].
class _Navigation extends State<Navigation> {
  late int selectedIndex;

  bool isSearchScreenModified = false;

  final Map<int, GlobalKey<NavigatorState>> _navigatorKeys = {};
  final Map<int, String> _navLabels = {};

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.initialIndex;
  }

  bool onNotificationPush(SearchModifiedNotification searchNotify) {
    isSearchScreenModified = searchNotify.isModified;
    return true;
  }

  void onBottomNavItemTapped(int index) {
    if (selectedIndex == index) {
      var nav = _navigatorKeys[index]?.currentState;
      if (nav == null) {
        return;
      }

      while (nav.canPop()) {
        nav.pop();
      }

      bool shouldResetSearch =
          _navLabels[index] == "Search" && isSearchScreenModified;

      if (shouldResetSearch) {
        searchKey.currentState?.reset();
      }
    }
    else {
      setState(() {
        selectedIndex = index;
      });
    }
  }

  /// Main widget containing app bar, page navigator, and bottom bar.
  @override
  Widget build(BuildContext context) {
    var appState = Provider.of<AppState>(context);
    var isParent = appState.isParent;

    List<Destination> enabledDest = getDest(isParent);
    List<Widget> pages = enabledDest.map((x) => x.widget).toList();

    return NotificationListener(
        onNotification: onNotificationPush,
        child: Scaffold(
            body: PopScope(
              canPop: false,
              onPopInvokedWithResult: (didPop, result) {
                var nav = _navigatorKeys[selectedIndex]?.currentState;
                if (nav != null && nav.canPop()) {
                  nav.pop(_navigatorKeys[selectedIndex]?.currentContext);
                } else {
                  // Uncomment below line to enable back button to close the app
                  //SystemChannels.platform.invokeMethod<void>('SystemNavigator.pop');
                }
              },
              child: IndexedStack(
                index: selectedIndex,
                children: List.generate(pages.length, (index) {
                  _navigatorKeys[index] = enabledDest[index].navState;
                  _navLabels[index] = enabledDest[index].label;
                  return Navigator(
                    key: enabledDest[index].navState,
                    onGenerateRoute: (settings) {
                      return MaterialPageRoute(
                        builder: (context) => pages[index],
                      );
                    },
                  );
                }),
              ),
            ),
            bottomNavigationBar: NavigationBar(
                backgroundColor: colorGreen,
                labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
                selectedIndex: selectedIndex,
                onDestinationSelected: onBottomNavItemTapped,
                destinations: getDestWidgets(isParent))));
  }
}

class Destination {
  String label;
  IconData icon;
  IconData selectedIcon;
  Widget widget;
  GlobalKey<NavigatorState> navState = GlobalKey<NavigatorState>();
  PageCategory pageType;

  Destination(
      {required this.label,
      required this.icon,
      required this.selectedIcon,
      required this.widget,
      this.pageType = PageCategory.both});
}

enum PageCategory { both, parent, teacher }

List<Destination> getDest(bool isParent) {
  PageCategory category = isParent ? PageCategory.parent : PageCategory.teacher;

  var list = dest.where((x) {
    return x.pageType == PageCategory.both || x.pageType == category;
  }).toList();

  return list;
}

List<Widget> getDestWidgets(bool isParent) {
  return getDest(isParent)
      .map((x) => NavigationDestination(
          selectedIcon: Icon(x.selectedIcon, color: colorGreenDark),
          icon: Icon(x.icon, color: colorWhite),
          label: x.label))
      .toList();
}

List<Destination> dest = [
  Destination(
      label: "Home",
      widget: const HomeScreen(),
      icon: Icons.home_outlined,
      selectedIcon: Icons.home),
  Destination(
      label: "Bookshelf",
      widget: const BookshelvesScreen(),
      icon: Icons.collections_bookmark_outlined,
      selectedIcon: Icons.collections_bookmark_rounded,
      pageType: PageCategory.parent),
  Destination(
      label: "Search",
      widget: SearchScreen(key: searchKey),
      icon: Icons.search_outlined,
      selectedIcon: Icons.search_rounded),
  Destination(
      label: "Progress",
      widget: const ProgressScreen(),
      icon: Icons.show_chart,
      selectedIcon: Icons.show_chart,
      pageType: PageCategory.parent),
  Destination(
      label: "Classroom",
      widget: const ClassroomScreen(),
      icon: Icons.school_outlined,
      selectedIcon: Icons.school,
      pageType: PageCategory.teacher),
  Destination(
      label: "Profile",
      widget: const ProfileScreen(),
      icon: Icons.account_circle_outlined,
      selectedIcon: Icons.account_circle_rounded)
];
