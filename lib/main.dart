import 'package:bookworms_app/app_state.dart';
import 'package:bookworms_app/screens/bookshelves_screen.dart';
import 'package:bookworms_app/screens/home/home_screen.dart';
import 'package:bookworms_app/screens/profile_screen.dart';
import 'package:bookworms_app/screens/progress_screen.dart';
import 'package:flutter/material.dart';
import 'package:bookworms_app/screens/search/search_screen.dart';
import 'package:provider/provider.dart';

void main() => runApp(const BookWorms());

class BookWorms extends StatelessWidget {
  const BookWorms({super.key});

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
  // Selected navigation tab (0-4).
  int selectedIndex = 0;
  
  // Navigation page widgets.
  final List<Widget> pages = const <Widget>[
    HomeScreen(),
    BookshelvesScreen(),
    SearchScreen(),
    ProgressScreen(),
    ProfileScreen(),
  ];


  /// Main widget containing app bar, page navigator, and bottom bar.
  @override
  Widget build(BuildContext context) {
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
      bottomNavigationBar: navigationBar()
    );
  }

  /// Bottom global navigation bar.
  /// Contains "Home", "Bookshelves", "Search", "Progress", and "Profile" tabs.
  Widget navigationBar() {
    return NavigationBar(
      backgroundColor: Colors.green[800],
      labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
      selectedIndex: selectedIndex,
      onDestinationSelected: (int index) {
        setState(() {
          selectedIndex = index;
        });
      },
      destinations: const <NavigationDestination>[
        NavigationDestination(
          selectedIcon: Icon(Icons.home), 
          icon: Icon(Icons.home_outlined, color: Colors.white), 
          label: "Home"
        ),
        NavigationDestination(
          selectedIcon: Icon(Icons.collections_bookmark_rounded), 
          icon: Icon(Icons.collections_bookmark_outlined, color: Colors.white), 
          label: "Bookshelf"
        ),
        NavigationDestination(
          selectedIcon: Icon(Icons.search_rounded), 
          icon: Icon(Icons.search_outlined, color: Colors.white), 
          label: "Search"
        ),
        NavigationDestination(
          selectedIcon: Icon(Icons.show_chart), 
          icon: Icon(Icons.show_chart, color: Colors.white), 
          label: "Progress"
        ),
        NavigationDestination(
          selectedIcon: Icon(Icons.account_circle_rounded), 
          icon: Icon(Icons.account_circle_outlined, color: Colors.white), 
          label: "Profile"
        ),
      ],
    );
  }
}