class Account {
  final String username;
  final String name;
  final String email;
  final String createdAt;

  const Account({
    required this.username,
    required this.name,
    required this.email,
    required this.createdAt,
  });

  // Decodes the JSON to create a Account object.
  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
      username: json['username'],
      name: json['name'],
      email: json['email'],
      createdAt: json['createdAt']
    );
  }
}