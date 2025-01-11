class Account {
  final String username;
  final String firstName;
  final String lastName;

  const Account({
    required this.username,
    required this.firstName,
    required this.lastName,
  });

  // Decodes the JSON to create a Account object.
  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
      username: json['username'],
      firstName: json['firstName'],
      lastName: json['lastName'],
    );
  }
}