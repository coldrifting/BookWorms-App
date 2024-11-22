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
        reviews.add(Padding(
          padding: const EdgeInsets.only(bottom: 24.0),
          child: userReview(),
        ));
    }
    return Column(
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

  Widget userReview() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
        boxShadow: [
      BoxShadow(
        color: Colors.grey.withOpacity(0.3),
        spreadRadius: 1,
        blurRadius: 5,
      ),
    ], // Rounded corners
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    IconButton( // Temporary button until an image replacement is made.
                      onPressed: (() => {}), 
                      icon: const Icon(Icons.person),
                    ),
                    const SizedBox(width: 5),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                          "Zoe West"
                        ),
                        Text("★★★★★"), // To be replaced with star calculation.
                      ],
                    ),
                    const SizedBox(width: 20),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200], // Background color
                        borderRadius: BorderRadius.circular(10), // Rounded corners
                      ),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 1),
                        child: Text("Parent"),
                      ),
                    ),
                  ],
                ),
                const Text("1 day ago"),
              ],
            ),
            const Text(
              textAlign: TextAlign.justify,
              "My child loves the giving tree! It sparked such great conversations about kindness and sharing."
              ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: (() => {}), 
                  icon: const Icon(Icons.more_horiz),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  } 
}