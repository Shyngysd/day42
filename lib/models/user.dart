import 'dart:convert';

class User {
  final String id;
  final String email;
  final String name;
  final String token;

  User({
    required this.id,
    required this.email,
    required this.name,
    required this.token,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] as String,
      token: json['token'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'token': token,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is User &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          email == other.email &&
          name == other.name &&
          token == other.token;

  @override
  int get hashCode =>
      id.hashCode ^ email.hashCode ^ name.hashCode ^ token.hashCode;

  @override
  String toString() =>
      'User(id: $id, email: $email, name: $name, token: $token)';
}
