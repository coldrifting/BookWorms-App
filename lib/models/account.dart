class Account {
  String username;
  String firstName;
  String lastName;
  int profilePictureIndex;
  final List<String> recentlySearchedBooks;

  Account({
    required this.username,
    required this.firstName,
    required this.lastName,
    required this.profilePictureIndex,
    required this.recentlySearchedBooks,
  });
}