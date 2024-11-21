import 'package:bookworms_app/Utils.dart';
import 'package:bookworms_app/app_state.dart';
import 'package:bookworms_app/book_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:bookworms_app/search_screen.dart';
import 'package:provider/provider.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AppState>(
      create: (context) => AppState(),
      child: MaterialApp(
        title: 'BookWorms',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
          useMaterial3: true,
        ),
        home: const Navigation()
      ),
    );
  }
}

class Navigation extends StatefulWidget {
  const Navigation({super.key});

  @override
  State<Navigation> createState() => _Navigation();
}

class _Navigation extends State<Navigation> {
  // Selected navigation tab (0-4)
  int selectedIndex = 0;
  
  // Home navigation page paths
  final List<String> pages = const [
    "/homepage",
    "/bookshelvespage",
    "/searchpage",
    "/progresspage",
    "/profilepage",
    "/bookdetailspage",
  ];

  /// Main widget containing app bar, page navigator, and bottom bar
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: 
        AppBar(
          title: const Text("App bar title"),
          backgroundColor:  Colors.green[200],
        ),
        body: Navigator(
          key: Utils.homeNav,
          initialRoute: pages[selectedIndex],
          onGenerateRoute: (RouteSettings settings) {
            Widget page;
            switch (settings.name) {
              case '/bookshelvespage':
                page = const Text("Bookshelves Page");
                break;
              case '/searchpage':
                page = const SearchScreen();
                break;
              case '/progresspage':
                page = const Text("Progress Page");
                break;
              case '/profilepage':
                page = const Text("Profile Page");
                break;
              case '/bookdetailspage':
                page = const BookDetailsScreen();
                break;
              default:
                page = const Text("Home Page");
            }
            return PageRouteBuilder(
              pageBuilder: (_, __, ___) => page,
              transitionDuration: const Duration(seconds: 0)
            );
          },
        ),
      bottomNavigationBar: navigationBar()
    );
  }

  /// Bottom global navigation bar
  /// Contains "Home", "Bookshelves", "Search", "Progress", and "Profile" tabs
  Widget navigationBar() {
    return NavigationBar(
      backgroundColor: Colors.green[200],
      labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
      selectedIndex: selectedIndex,
      onDestinationSelected: (int index) {
        setState(() {
          selectedIndex = index;
          Utils.homeNav.currentState?.pushReplacementNamed(pages[index]);
        });
      },
      destinations: const <NavigationDestination>[
        NavigationDestination(
          selectedIcon: Icon(Icons.home), 
          icon: Icon(Icons.home_outlined), 
          label: "Home"
        ),
        NavigationDestination(
          selectedIcon: Icon(Icons.collections_bookmark_rounded), 
          icon: Icon(Icons.collections_bookmark_outlined), 
          label: "Bookshelf"
        ),
        NavigationDestination(
          selectedIcon: Icon(Icons.search_rounded), 
          icon: Icon(Icons.search_outlined), 
          label: "Search"
        ),
        NavigationDestination(
          selectedIcon: Icon(Icons.show_chart), 
          icon: Icon(Icons.show_chart), 
          label: "Progress"
        ),
        NavigationDestination(
          selectedIcon: Icon(Icons.account_circle_rounded), 
          icon: Icon(Icons.account_circle_outlined), 
          label: "Profile"
        ),
      ],
    );
  }
}