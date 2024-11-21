import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BookDetailsScreen extends StatefulWidget {
  const BookDetailsScreen({super.key});

  @override
  State<BookDetailsScreen> createState() => _BookDetailsScreenState();
}

class _BookDetailsScreenState extends State<BookDetailsScreen> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController(initialScrollOffset: 250);
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      controller: _scrollController,
      children: [
        Image.network("https://m.media-amazon.com/images/I/71wiGMKadmL._AC_UF1000,1000_QL80_.jpg"),
        bookDetails(),
        Container(
          color: const Color.fromARGB(255, 239, 239, 239),
          child: Column(
            children: [
              actionButtons(),
              reviewList(),
            ],
          ),
        ),
      ]
    );
  }

  Widget bookDetails() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          const Text(
            style: TextStyle(
                fontWeight: FontWeight.bold, 
                fontSize: 28,
             ),
            "The Giving Tree"
          ),
          const Text(
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
                fontSize: 18,
            ), 
            "Shel Silverstein"
          ),
          const Padding(
            padding: EdgeInsets.all(12.0),
            child: Text(
              style: 
              TextStyle(
                fontSize: 16.0
              ),
              "Level A   |   4.9★"
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: RichText(
              textAlign: TextAlign.justify,
              text: const TextSpan(
                style: TextStyle(
                  color: Colors.black, 
                  fontSize: 16.0,
                ), // Regular text
                children: <TextSpan>[
                  TextSpan(
                    text: 'Description: ',
                    style: TextStyle(fontWeight: FontWeight.bold), // Bold text
                  ),
                  TextSpan(
                    text: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam tincidunt dictum sem eget aliquam. Quisque finibus mi et dui dignissim malesuada. Phasellus et tellus enim. Orci varius natoque penatibus ...',
                  ),
                ],
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.keyboard_arrow_down_sharp),
            onPressed: () => {},
          ),
        ]
      ),
    );
  }

  Widget actionButtons() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ElevatedButton.icon(
            icon: const Icon(Icons.bookmark),
            onPressed: (() => {}),
            label: const Text("Save")),
          ElevatedButton.icon(
            icon: const Icon(Icons.account_balance),
            onPressed: (() => {}),
            label: const Text("Locate")),
          ElevatedButton.icon(
            icon: const Icon(Icons.fitness_center),
            onPressed: (() => {}),
            label: const Text("Rate")),
        ],
      ),
    );
  }

  Widget reviewList() {
    List<Widget> reviews = [];
    for (var i = 0; i < 1000; i++) {
        reviews.add(Text("REVIEW $i"));
      }
    return Column(children: reviews);
  }  
}