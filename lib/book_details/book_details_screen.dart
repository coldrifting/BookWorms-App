import 'package:bookworms_app/book_details/user_review.dart';
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
    // The initial offset allows for a partial section of the book to be shown
    // on the book details view.
    _scrollController = ScrollController(initialScrollOffset: 250);
  }

  /// The entire book details page, containing book image, details, action buttons,
  /// and reviews.
  @override
  Widget build(BuildContext context) {
    return ListView(
      controller: _scrollController,
      children: [
        // Temporary image for testing purposes.
        Image.network("https://m.media-amazon.com/images/I/71wiGMKadmL._AC_UF1000,1000_QL80_.jpg"),
        bookDetails(),
        Container(
          color: const Color.fromARGB(255, 239, 239, 239),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const SizedBox(height: 5),
                actionButtons(),
                const SizedBox(height: 15),
                reviewList(),
              ],
            ),
          ),
        ),
      ]
    );
  }

  /// Sub-section containing book information such as title, author, rating,
  /// difficulty, and description.
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

  /// Buttons for saving a book to a bookshelf, locating a near library, and
  /// rating the book difficulty.
  Widget actionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
    );
  }

  // Temporarily generate a list of reviews for testing.
  Widget reviewList() {
    List<Widget> reviews = [];
    for (var i = 0; i < 30; i++) {
      reviews.add(const Padding(
        padding: EdgeInsets.only(bottom: 18.0),
        child: UserReview(
          name: 'Zoe West', 
          icon: Icons.person , 
          role: "Parent", 
          date: "11/22/2024", 
          reviewText: "My child loves the giving tree! It sparked such great conversations about kindness and sharing.", 
          starRating: "4.5"
        ),
      ));
    }

    return Column( // Replace with lazy loading.
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              "Reviews  |  4.9★",
            ),
            IconButton(
              onPressed: (() => {}), 
              icon: const Icon(Icons.add),
            ),
          ],
        ),
        ...reviews,
      ],
    );
  } 
}