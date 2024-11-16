import 'package:flutter/material.dart';

class BookDetailsScreen extends StatefulWidget {
  const BookDetailsScreen({super.key});

  @override
  State<BookDetailsScreen> createState() => _BookDetailsScreenState();
}

class _BookDetailsScreenState extends State<BookDetailsScreen> { 
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Image.network("https://m.media-amazon.com/images/I/71wiGMKadmL._AC_UF1000,1000_QL80_.jpg"),
        Column(
          children: [
            const Text("The Giving Tree"),
            const Text("Shel Silverstein"),
            const Text("Description: ..."),
            IconButton(
              icon: const Icon(Icons.keyboard_arrow_down_sharp),
              onPressed: () => {},
            )
          ]
        )
      ],
    );
  }

  
}