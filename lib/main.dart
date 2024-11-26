import 'package:bookworms_app/app_state.dart';
import 'package:flutter/material.dart';
import 'package:bookworms_app/search/search_screen.dart';
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
  // Selected navigation tab (0-4).
  int selectedIndex = 0;
  
  // Navigation page widgets.
  final List<Widget> pages = const <Widget>[
    Center(child: Text("Home Page")),
    Center(child: Text("Bookshelves Page")),
    SearchScreen(),
    Center(child: Text("Progress Page")),
    Center(child: Text("Profile Page")),
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
      backgroundColor: Colors.green[200],
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