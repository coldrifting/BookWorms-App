class UserLogin {
  final String token;

  UserLogin({
    required this.token,
  });

  factory UserLogin.fromJson(Map<String, dynamic> json) {
    return UserLogin(
        token: json['token']
    );
  }
}