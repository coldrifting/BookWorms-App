//import 'package:bookworms_app/models/BookSummary.dart';
import 'package:bookworms_app/home/bookshelf_widget.dart';
import 'package:bookworms_app/models/BookSummary.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  // ********************
  // Temporary images and books for demo
  static const image1 = "http://books.google.com/books/content?id=dJNoDQAAQBAJ&printsec=frontcover&img=1&zoom=4&edge=curl&source=gbs_api";
  static const image2 = "http://books.google.com/books/content?id=zH2WQ5FHsHcC&printsec=frontcover&img=1&zoom=4&edge=curl&source=gbs_api";
  static const image3 = "http://books.google.com/books/content?id=f_QUAgAAQBAJ&printsec=frontcover&img=1&zoom=4&edge=curl&source=gbs_api";
  static const image4 = "http://books.google.com/books/content?id=l39QAwAAQBAJ&printsec=frontcover&img=1&zoom=4&edge=curl&source=gbs_api";
  static const image5 = "http://books.google.com/books/content?id=iRIcS_gvRMcC&printsec=frontcover&img=1&zoom=4&edge=curl&source=gbs_api";
  static const image6 = "http://books.google.com/books/content?id=rYy8CwAAQBAJ&printsec=frontcover&img=1&zoom=4&source=gbs_api";
  static const image7 = "http://books.google.com/books/content?id=td0nDwAAQBAJ&printsec=frontcover&img=1&zoom=4&edge=curl&source=gbs_api";
  static const image8 = "http://books.google.com/books/content?id=H5zQDAAAQBAJ&printsec=frontcover&img=1&zoom=4&edge=curl&source=gbs_api";
  static const image9 = "http://books.google.com/books/content?id=B344DwAAQBAJ&printsec=frontcover&img=1&zoom=4&edge=curl&source=gbs_api";
  static const image10 = "http://books.google.com/books/content?id=yKLbDwAAQBAJ&printsec=frontcover&img=1&zoom=4&edge=curl&source=gbs_api";

  static const book1 = BookSummary(id: "", title: "Goodnight Moon", authors: ["Margarel Wise Brown"], difficulty: "Level A", rating: 4.6);
  static const book2 = BookSummary(id: "", title: "Clifford the Big Red Dog", authors: ["Norman Bridwell"], difficulty: "Level B", rating: 4.8);
  static const book3 = BookSummary(id: "", title: "Curious George: A House for Honeybees", authors: ["H. A. Rey"], difficulty: "Level C", rating: 4.5);
  static const book4 = BookSummary(id: "", title: "The Little Prince", authors: ["Antoine de Saint-Exupery"], difficulty: "Level E", rating: 4.3);
  static const book5 = BookSummary(id: "", title: "Brown Bear, Brown Bear, What Do You See?", authors: ["Bill Martin, Jr."], difficulty: "Level C", rating: 3.9);
  static const book6 = BookSummary(id: "", title: "The Koala Who Could", authors: ["Rachel Bright"], difficulty: "Level D", rating: 3.0);
  static const book7 = BookSummary(id: "", title: "The Rainbow Fish", authors: ["Marcus Pfister"], difficulty: "Level B", rating: 4.2);
  static const book8 = BookSummary(id: "", title: "Goldilocks and the Tree Bears", authors: ["Jan Brett"], difficulty: "Level D", rating: 4.8);
  static const book9 = BookSummary(id: "", title: "Beauty and the Beast", authors: ["Teddy Slater"], difficulty: "Level E", rating: 5.0);
  static const book10 = BookSummary(id: "", title: "Hansel and Gretel", authors: ["Brothers Grimm"], difficulty: "Level E", rating: 4.6);

  // ********************

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
          const BookshelfWidget(name: "Recommended", images: [image1, image2, image3, image4], books: [book1, book2, book3, book4]),
          const SizedBox(height: 24),
          _progressTracker(),
          const SizedBox(height: 24),
          const BookshelfWidget(name: "Animals", images: [image2, image5, image6, image7], books: [book2, book5, book6, book7]),
          const SizedBox(height: 24),
          const BookshelfWidget(name: "Fairytales", images: [image8, image9, image7, image10], books: [book8, book9, book7, book10]),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

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