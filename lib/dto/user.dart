import 'dart:convert';

class UserDto {
  final int id;
  final String? username;
  final String? fullName;
  final String? email;
  final String? googleId;
  final String? googleEmail;
  final bool? hasPassword;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? photoUrl;

  UserDto({
    required this.id,
    this.username,
    this.fullName,
    this.email,
    this.googleId,
    this.googleEmail,
    this.hasPassword,
    required this.createdAt,
    required this.updatedAt,
    this.photoUrl,
  });

  factory UserDto.fromJson(Map<String, dynamic> json) {
    String? emptyToNull(String? value) {
      if (value == null || value.trim().isEmpty) return null;
      return value;
    }

    return UserDto(
      id: json['id'] as int,
      username: emptyToNull(json['username'] as String?),
      fullName: emptyToNull(json['fullName'] as String?),
      email: emptyToNull(json['email'] as String?),
      googleId: emptyToNull(json['googleId'] as String?),
      googleEmail: emptyToNull(json['googleEmail'] as String?),
      hasPassword: json['hasPassword'] as bool?,
      photoUrl: emptyToNull(json['photoUrl'] as String?),
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
      'googleId': googleId,
      'googleEmail': googleEmail,
      'hasPassword': hasPassword,
      'photoUrl': photoUrl,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  String toJsonString() => jsonEncode(toJson());

  factory UserDto.fromJsonString(String source) =>
      UserDto.fromJson(jsonDecode(source));

  UserDto copyWith({
    String? fullName,
    String? photoUrl,
    DateTime? updatedAt,
    String? username,
    String? email,
    String? googleId,
    String? googleEmail,
    bool? hasPassword,
  }) {
    return UserDto(
      id: id,
      username: username ?? this.username,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      googleId: googleId ?? this.googleId,
      googleEmail: googleEmail ?? this.googleEmail,
      hasPassword: hasPassword ?? this.hasPassword,
      photoUrl: photoUrl ?? this.photoUrl,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}


class UpdateUserDto {
  String username;
  String? fullName;
  String email;
  UpdateUserDto({required this.username, this.fullName, required this.email});
}
