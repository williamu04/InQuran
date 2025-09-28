import 'dart:convert';

class UserDto {
  final int id;
  final String username;
  final String? fullName;
  final String email;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? photoUrl;

  UserDto({
    required this.id,
    required this.username,
    this.fullName,
    required this.email,
    required this.createdAt,
    required this.updatedAt,
    this.photoUrl,
  });

  factory UserDto.fromJson(Map<String, dynamic> json) {
    final fullNameValue = json['fullName'] as String?;
    return UserDto(
      id: json['id'] as int,
      username: json['username'] as String,
      fullName: (fullNameValue == null || fullNameValue.isEmpty) ? null : fullNameValue,
      email: json['email'] as String,
      photoUrl: json['photoUrl'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'fullName': fullName,
      'email': email,
      'photoUrl': photoUrl,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  String toJsonString() => jsonEncode(toJson());

  factory UserDto.fromJsonString(String source) =>
      UserDto.fromJson(jsonDecode(source));
}
