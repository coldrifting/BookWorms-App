import 'package:bookworms_app/app_state.dart';
import 'package:flutter/material.dart';
import 'package:bookworms_app/search_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';

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
  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            activeIcon: Icon(Icons.home), 
            icon: Icon(Icons.home_outlined), 
            label: "Home"
          ),
          BottomNavigationBarItem(
            activeIcon: Icon(Icons.collections_bookmark_rounded), 
            icon: Icon(Icons.collections_bookmark_outlined), 
            label: "Bookshelf"
          ),
          BottomNavigationBarItem(
            activeIcon: Icon(Icons.search_rounded), 
            icon: Icon(Icons.search_outlined), 
            label: "Search"
          ),
          BottomNavigationBarItem(
            activeIcon: Icon(Icons.show_chart), 
            icon: Icon(Icons.show_chart), 
            label: "Progress"
          ),
          BottomNavigationBarItem(
              activeIcon: Icon(Icons.account_circle_rounded), 
              icon: Icon(Icons.account_circle_outlined), 
              label: "Profile"
          ),
        ],
      ),
      tabBuilder: (BuildContext context, int index) {
        return CupertinoTabView(
          builder: (BuildContext context) {
            Widget tab;
            switch(index) {
              case 1:
                tab = Scaffold(body: Center(child: Text("Page Bookshelves")));
                break;
              case 2:
                tab = SearchScreen();
                break;
              case 3:
                tab = Scaffold(body: Center(child: Text("Page Progress")));
                break;
              case 4:
                tab = Scaffold(body: Center(child: Text("Page Account")));
                break;
              default:
                tab = Scaffold(body: Center(child: Text("Page Home")));
            }
            return tab;
          },
        );
      },
    );
  }
}