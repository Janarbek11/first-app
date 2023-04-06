class UserModel {
  final String name;
  final String email;
  final List<int> password;

  UserModel({
    required this.name,
    required this.email,
    required this.password,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    final passwordString = map['password'] as String;
    final passwordParts = passwordString.split(':');
    final hashedPassword = passwordParts[0];
    final salt = passwordParts[1];

    return UserModel(
      name: map['name'] as String,
      email: map['email'] as String,
      password: [hashedPassword, salt].map((e) => int.parse(e)).toList(),
    );
  }
}