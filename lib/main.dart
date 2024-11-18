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
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const Navigation(),
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
  var selectedPageIndex = 0;
  final List<Widget> pages = const <Widget>[
    BookDetailsScreen(),
    Center(
      child: Text("Page Bookshelves")),
    SearchScreen(),
    Center(
      child: Text("Page Progress")
      ),
    Center(
      child: Text("Page Account"))
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: 
        AppBar(
          title: const Text("App bar title"),
          backgroundColor:  Colors.green[200],
        ),
      body: IndexedStack(
        index: selectedPageIndex,
        children: pages,
      ),
      bottomNavigationBar: 
        NavigationBar(
          backgroundColor: Colors.green[200],
          labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
          selectedIndex: selectedPageIndex,
          onDestinationSelected: (int index) {
            setState(() {
              selectedPageIndex = index;
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
        ),
      );
  }
}