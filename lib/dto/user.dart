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
    return UserDto(
      id: json['id'] as int,
      username: json['username'] as String,
      fullName: json['fullName'] as String?,
      email: json['email'] as String,
      photoUrl: json['photoUrl'],
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }
}
