//import 'package:bookworms_app/models/BookSummary.dart';
import 'package:bookworms_app/screens/home/bookshelf_widget.dart';
import 'package:flutter/material.dart';
// Books used for the demo
import 'package:bookworms_app/demo_books.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Johnny's Home", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.green[800],
      ),
      body: ListView(
        children: [
          const SizedBox(height: 16),
          BookshelfWidget(name: "Recommended", images: [Demo.image1, Demo.image2, Demo.image3, Demo.image4], books: [Demo.book1, Demo.book2, Demo.book3, Demo.book4]),
          const SizedBox(height: 24),
          _progressTracker(),
          const SizedBox(height: 24),
          BookshelfWidget(name: "Animals", images: [Demo.image2, Demo.image5, Demo.image6, Demo.image7], books: [Demo.book2, Demo.book5, Demo.book6, Demo.book7]),
          const SizedBox(height: 24),
          BookshelfWidget(name: "Fairytales", images: [Demo.image8, Demo.image9, Demo.image7, Demo.image10], books: [Demo.book8, Demo.book9, Demo.book7, Demo.book10]),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  /// Displays the up-to-date progress of the currently-selected child.
  Widget _progressTracker() {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 6,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                "Johnny's Progress"
              ),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  style: TextStyle(fontSize: 16),
                  "No progress to display"
                ),
              ),
            ),
          ]
        ),
      ),
    );
  }
}