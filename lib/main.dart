import 'package:bookworms_app/screens/setup/splash_screen.dart';
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

void main() => runApp(const BookWorms());


final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

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
          PointerDeviceKind.trackpad,})
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

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.initialIndex;
  }

  /// Main widget containing app bar, page navigator, and bottom bar.
  @override
  Widget build(BuildContext context) {
    var appState = Provider.of<AppState>(context);
    var isParent = appState.isParent;
  
    List<Widget> pages = [
      const HomeScreen(),
      if (isParent) const BookshelvesScreen(),
      const SearchScreen(),
      if (isParent) const ProgressScreen(),
      if (!isParent) ClassroomScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      body: IndexedStack(
        index: selectedIndex,
        children: List.generate(pages.length, (index) {
          return Navigator(
            onGenerateRoute: (settings) {
              return MaterialPageRoute(
                builder: (context) => pages[index],
              );
            },
          );
        }),
      ),
      bottomNavigationBar: navigationBar(isParent)
    );
  }

  /// Bottom global navigation bar.
  /// Contains "Home", "Bookshelves", "Search", "Progress", and "Profile" tabs.
  Widget navigationBar(bool isParent) {
    return NavigationBar(
      backgroundColor: colorGreen,
      labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
      selectedIndex: selectedIndex,
      onDestinationSelected: (int index) {
        if (selectedIndex == index) {
          Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => Navigation(initialIndex: index)),
            (route) => false,
          );
      } else {
        setState(() {
          selectedIndex = index;
        });
      }
      },
      destinations: <NavigationDestination>[
        const NavigationDestination(
          selectedIcon: Icon(Icons.home), 
          icon: Icon(Icons.home_outlined, color: colorWhite), 
          label: "Home"
        ),
        if (isParent)
          const NavigationDestination(
            selectedIcon: Icon(Icons.collections_bookmark_rounded), 
            icon: Icon(Icons.collections_bookmark_outlined, color: colorWhite), 
            label: "Bookshelf"
          ),
        const NavigationDestination(
          selectedIcon: Icon(Icons.search_rounded), 
          icon: Icon(Icons.search_outlined, color: colorWhite), 
          label: "Search"
        ),
        if (isParent) 
          const NavigationDestination(
            selectedIcon: Icon(Icons.show_chart), 
            icon: Icon(Icons.show_chart, color: colorWhite), 
            label: "Progress"
          ),
        if (!isParent)
          const NavigationDestination(
            selectedIcon: Icon(Icons.school), 
            icon: Icon(Icons.school_outlined, color: colorWhite), 
            label: "Classroom"
          ),
        const NavigationDestination(
          selectedIcon: Icon(Icons.account_circle_rounded), 
          icon: Icon(Icons.account_circle_outlined, color: colorWhite), 
          label: "Profile"
        ),
      ],
    );
  }
}