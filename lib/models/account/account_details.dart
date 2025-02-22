class AccountDetails {
  final String username;
  final String firstName;
  final String lastName;
  final String role;
  final int profilePictureIndex;

  AccountDetails({
    required this.username,
    required this.firstName,
    required this.lastName,
    required this.role,
    required this.profilePictureIndex,
  });

  factory AccountDetails.fromJson(Map<String, dynamic> json) {
    return AccountDetails(
      username: json['username'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      role: json['role'],
      profilePictureIndex: json['icon'],
    );
  }
}