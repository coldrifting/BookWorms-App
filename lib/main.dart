import 'package:bookworms_app/app_state.dart';
import 'package:bookworms_app/resources/colors.dart';
import 'package:bookworms_app/resources/theme.dart';
import 'package:bookworms_app/screens/bookshelves/bookshelves_screen.dart';
import 'package:bookworms_app/screens/classroom/classroom_screen.dart';
import 'package:bookworms_app/screens/goals/child_progress_screen.dart';
import 'package:bookworms_app/screens/home_screen.dart';
import 'package:bookworms_app/screens/profile/profile_screen.dart';
import 'package:bookworms_app/screens/search/search_screen.dart';
import 'package:bookworms_app/screens/setup/splash_screen.dart';
import 'package:bookworms_app/showcase/showcase_controller.dart';
import 'package:bookworms_app/showcase/showcase_widgets.dart';
import 'package:collection/collection.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:showcaseview/showcaseview.dart';

void main() => runApp(const BookWorms());

// Root navigator key
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

// Need a reference to search state to be able to reset it
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
        child: ShowCaseWidget(
          builder: (context) =>
            MaterialApp(
                navigatorKey: navigatorKey,
                title: 'BookWorms',
                theme: appTheme,
                home: const SplashScreen(),
                scrollBehavior: const ScrollBehavior().copyWith(dragDevices: {
                  PointerDeviceKind.touch,
                  PointerDeviceKind.mouse,
                  PointerDeviceKind.stylus,
                  PointerDeviceKind.trackpad,
                })
            )
        )
    );
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
  late final showcaseController = ShowcaseController();
  late final List<GlobalKey> navKeys = showcaseController.getKeysForScreen('navigation');

  bool isSearchScreenModified = false;

  final Map<int, GlobalKey<NavigatorState>> _navigatorKeys = {};
  int searchTabIndex = -1;

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

      if (index == searchTabIndex && isSearchScreenModified) {
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
    // This can safely be done here, since Navigation is the first widget to
    //  be built once the user type is known
    showcaseController.initialize(context, onBottomNavItemTapped);

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
              child: Stack(
                children: [
                  IndexedStack(
                    index: selectedIndex,
                    children: List.generate(pages.length, (index) {
                      if (enabledDest[index].label == "Search") {
                        searchTabIndex = index;
                      }
                      _navigatorKeys[index] = enabledDest[index].navState;
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

                  // Invisible element for showing showcase welcome
                  Positioned(
                    top: 350,
                    left: 0,
                    right: 0,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          BWShowcase(
                              showcaseKey: navKeys[0],
                              title: "Welcome to BookWorms!",
                              description: "Let us show you around.\nYou can view this tutorial again\nat any time from the Profile page.",
                              disableMovingAnimation: true,
                              tooltipActions: ["Skip tutorial", "Get Started"],
                              showArrow: false,
                              child: SizedBox(
                                  width: 0,
                                  height: 0
                              )
                          )
                        ]
                    ),
                  ),

                  // Invisible element for showing showcase conclusion
                  Positioned(
                    top: 350,
                    left: 0,
                    right: 0,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          BWShowcase(
                              showcaseKey: navKeys.last,
                              title: "You're all ready!",
                              description: "You can view this tutorial again\nat any time from the Profile page.",
                              disableMovingAnimation: true,
                              showArrow: false,
                              child: SizedBox(
                                  width: 0,
                                  height: 0
                              )
                          )
                        ]
                    ),
                  )
                ]
              ),
            ),
            bottomNavigationBar: NavigationBar(
                backgroundColor: colorGreen,
                labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
                selectedIndex: selectedIndex,
                onDestinationSelected: onBottomNavItemTapped,
                destinations: getDestWidgets(isParent, navKeys)
            )
        )
    );
  }
}

class Destination {
  String label;
  IconData icon;
  IconData selectedIcon;
  String showcaseDescription;
  Widget widget;
  GlobalKey<NavigatorState> navState = GlobalKey<NavigatorState>();
  PageCategory pageType;

  Destination(
      {required this.label,
      required this.icon,
      required this.selectedIcon,
      required this.showcaseDescription,
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

List<Widget> getDestWidgets(bool isParent, List<GlobalKey> navKeys) {
  return getDest(isParent)
      .mapIndexed((index, dest) =>
        BWShowcase(
          showcaseKey: navKeys[index + 1],
          description: dest.showcaseDescription,
          toScreen: index,
          tooltipActions: dest.label == "Home" ? ["Next"] : ["Previous", "Next"],
          tooltipAlignment: dest.label == "Home" ? MainAxisAlignment.end : null,
          child: NavigationDestination(
              selectedIcon: Icon(dest.selectedIcon, color: colorGreenDark),
              icon: Icon(dest.icon, color: colorWhite),
              label: dest.label
          ),
        )
      ).toList();
}

List<Destination> dest = [
  Destination(
      label: "Home",
      widget: const HomeScreen(),
      icon: Icons.home_outlined,
      showcaseDescription: "Visit the Home screen to see upcoming goals, a progress summary, and more.",
      selectedIcon: Icons.home),
  Destination(
      label: "Bookshelf",
      widget: const BookshelvesScreen(),
      icon: Icons.collections_bookmark_outlined,
      selectedIcon: Icons.collections_bookmark_rounded,
      showcaseDescription: "You can manage custom book lists on the Bookshelves screen.",
      pageType: PageCategory.parent),
  Destination(
      label: "Search",
      widget: SearchScreen(key: searchKey),
      icon: Icons.search_outlined,
      showcaseDescription: "Find a wide variety of books using the Search screen.",
      selectedIcon: Icons.search_rounded),
  Destination(
      label: "Progress",
      widget: const ProgressScreen(),
      icon: Icons.show_chart,
      selectedIcon: Icons.show_chart,
      showcaseDescription: "Visit the Progress screen to track your child's goals and progress.",
      pageType: PageCategory.parent),
  Destination(
      label: "Classroom",
      widget: const ClassroomScreen(),
      icon: Icons.school_outlined,
      selectedIcon: Icons.school,
      showcaseDescription: "Visit the Classroom screen to manage your classroom's bookshelves, goals, and more.",
      pageType: PageCategory.teacher),
  Destination(
      label: "Profile",
      widget: const ProfileScreen(),
      icon: Icons.account_circle_outlined,
      showcaseDescription: "Customize and manage your account from the Profile screen.",
      selectedIcon: Icons.account_circle_rounded)
];
