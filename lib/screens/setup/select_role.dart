import 'package:bookworms_app/screens/home/bookshelf_widget.dart';
import 'package:flutter/material.dart';
// Books used for the demo
import 'package:bookworms_app/demo_books.dart';

/// The [SelectRole] contains...
class SelectRole extends StatefulWidget {
  const SelectRole({super.key});

  @override
  State<SelectRole> createState() => _SelectRoleState();
}

/// The state of the [SelectRole].
class _SelectRoleState extends State<SelectRole> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Bookshelves list
      body: ListView(
        children: [
          const SizedBox(height: 16),
          BookshelfWidget(name: "Recommended", images: [Demo.image1, Demo.image2, Demo.image3, Demo.image4], books: [Demo.book1, Demo.book2, Demo.book3, Demo.book4]),
          const SizedBox(height: 24),
          const SizedBox(height: 24),
          BookshelfWidget(name: "Animals", images: [Demo.image2, Demo.image5, Demo.image6, Demo.image7], books: [Demo.book2, Demo.book5, Demo.book6, Demo.book7]),
          const SizedBox(height: 24),
          BookshelfWidget(name: "Fairytales", images: [Demo.image8, Demo.image9, Demo.image7, Demo.image10], books: [Demo.book8, Demo.book9, Demo.book7, Demo.book10]),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}