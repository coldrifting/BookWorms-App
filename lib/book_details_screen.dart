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
    _scrollController = ScrollController(initialScrollOffset: 400);
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      controller: _scrollController,
      children: [
        Image.network("https://m.media-amazon.com/images/I/71wiGMKadmL._AC_UF1000,1000_QL80_.jpg"),
        bookDetails(),
        actionButtons(),
        reviewList(),
      ]
    );
  }

  Widget bookDetails() {
    return Column(
      children: [
        const Text("The Giving Tree"),
        const Text("Shel Silverstein"),
        const Text("Description: ..."),
        IconButton(
          icon: const Icon(Icons.keyboard_arrow_down_sharp),
          onPressed: () => {},
        ),
      ]
    );
  }

  Widget actionButtons() {
    return Row(
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