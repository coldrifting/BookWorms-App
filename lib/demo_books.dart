import 'package:bookworms_app/models/book/book_summary.dart';

/// Temporary constant values for demo purposes.
class Demo {
  static const imagePrefix = "https://covers.openlibrary.org/b/id/";
  static const imageSuffix = "-L.jpg";

  static const image1  = "${imagePrefix}35556$imageSuffix";
  static const image2  = "${imagePrefix}279572$imageSuffix";
  static const image3  = "${imagePrefix}0008348270$imageSuffix";
  static const image4  = "${imagePrefix}115508$imageSuffix";
  static const image5  = "${imagePrefix}7728594$imageSuffix";
  static const image6  = "${imagePrefix}10114211$imageSuffix";
  static const image7  = "${imagePrefix}9013596$imageSuffix";
  static const image8  = "${imagePrefix}446199$imageSuffix";
  static const image9  = "${imagePrefix}6490919$imageSuffix";
  static const image10 = "${imagePrefix}0008843523$imageSuffix";

  static var book1 = BookSummary(id: "", title: "Goodnight Moon", authors: ["Margarel Wise Brown"], difficulty: "Level A", rating: 4.6);
  static var book2 = BookSummary(id: "", title: "Clifford the Big Red Dog", authors: ["Norman Bridwell"], difficulty: "Level B", rating: 4.8);
  static var book3 = BookSummary(id: "", title: "Curious George: A House for Honeybees", authors: ["H. A. Rey"], difficulty: "Level C", rating: 4.5);
  static var book4 = BookSummary(id: "", title: "The Little Prince", authors: ["Antoine de Saint-Exupery"], difficulty: "Level E", rating: 4.3);
  static var book5 = BookSummary(id: "", title: "Brown Bear, Brown Bear, What Do You See?", authors: ["Bill Martin, Jr."], difficulty: "Level C", rating: 3.9);
  static var book6 = BookSummary(id: "", title: "The Koala Who Could", authors: ["Rachel Bright"], difficulty: "Level D", rating: 3.0);
  static var book7 = BookSummary(id: "", title: "The Rainbow Fish", authors: ["Marcus Pfister"], difficulty: "Level B", rating: 4.2);
  static var book8 = BookSummary(id: "", title: "Goldilocks and the Three Bears", authors: ["Jan Brett"], difficulty: "Level D", rating: 4.8);
  static var book9 = BookSummary(id: "", title: "Beauty and the Beast", authors: ["Teddy Slater"], difficulty: "Level E", rating: 5.0);
  static var book10 = BookSummary(id: "", title: "Hansel and Gretel", authors: ["Brothers Grimm"], difficulty: "Level E", rating: 4.6);

  static var authors1 = ["Margaret Wise Brown"];
  static var authors2 = ["Norman Bridwell"];
  static var authors3 = ["H. A. Rey"];
  static var authors4 = ["Antoine de Saint-Exupery"];
  static var authors5 = ["Bill Martin, Jr."];
  static var authors6 = ["Rachel Bright"];
  static var authors7 = ["Marcus Pfister"];
  static var authors8 = ["Jan Brett"];
  static var authors9 = ["Teddy Slater"];
  static var authors10 = ["Brothers Grimm"];
}