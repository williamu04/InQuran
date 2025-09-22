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
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }
}
