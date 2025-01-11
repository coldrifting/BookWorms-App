import 'package:bookworms_app/app_state.dart';
import 'package:bookworms_app/screens/bookshelves_screen.dart';
import 'package:bookworms_app/screens/home/home_screen.dart';
import 'package:bookworms_app/screens/profile_screen.dart';
import 'package:bookworms_app/screens/progress_screen.dart';
import 'package:bookworms_app/screens/setup/welcome_screen.dart';
import 'package:bookworms_app/services/auth_storage.dart';
import 'package:bookworms_app/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:bookworms_app/screens/search/search_screen.dart';
import 'package:provider/provider.dart';

void main() => runApp(const BookWorms());

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
        title: 'BookWorms',
        theme: ThemeData(primaryColor: colorBlack, 
          textTheme: textThemeDefault, 
          fontFamily: "Montserrat", 
          useMaterial3: true
        ),
        home: const SplashScreen()
      ),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _tokenNavigate();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }

  Future<void> _tokenNavigate() async {
    final splashDelay = Future.delayed(const Duration(seconds: 2));
    var token = getToken();

    final results = await Future.wait([splashDelay, token]);

    if (mounted) {
      if (results[1] != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const Navigation()),
      );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const WelcomeScreen()),
        );
      }
    }
  }
}

/// The [Navigation] deals with the main bottom bar navigation between the
/// "Home", "Bookshelves", "Search", "Progress", and "Profile" screens.
class Navigation extends StatefulWidget {
  const Navigation({super.key});

  @override
  State<Navigation> createState() => _Navigation();
}

/// The state of the [Navigation].
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
      backgroundColor: colorGreen,
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
          icon: Icon(Icons.home_outlined, color: colorWhite), 
          label: "Home"
        ),
        NavigationDestination(
          selectedIcon: Icon(Icons.collections_bookmark_rounded), 
          icon: Icon(Icons.collections_bookmark_outlined, color: colorWhite), 
          label: "Bookshelf"
        ),
        NavigationDestination(
          selectedIcon: Icon(Icons.search_rounded), 
          icon: Icon(Icons.search_outlined, color: colorWhite), 
          label: "Search"
        ),
        NavigationDestination(
          selectedIcon: Icon(Icons.show_chart), 
          icon: Icon(Icons.show_chart, color: colorWhite), 
          label: "Progress"
        ),
        NavigationDestination(
          selectedIcon: Icon(Icons.account_circle_rounded), 
          icon: Icon(Icons.account_circle_outlined, color: colorWhite), 
          label: "Profile"
        ),
      ],
    );
  }
}