import 'package:mtqmnuns/dto/user.dart';

class TokenDto {
  final String sessionId;
  final String jwtToken;
  final String refreshToken;

  TokenDto({
    required this.sessionId,
    required this.jwtToken,
    required this.refreshToken,
  });

  factory TokenDto.fromJson(Map<String, dynamic> json) {
    return TokenDto(
      sessionId: json['sessionId'] as String,
      jwtToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String,
    );
  }
}

class TokenWithUserDto {
  TokenDto token;
  UserDto user;
  TokenWithUserDto(this.token, this.user);
}
class GoogleTokenWithUserDto {
  TokenDto token;
  UserDto user;
  bool isNew;
  GoogleTokenWithUserDto(this.token, this.user, this.isNew);
}
class GoogleUserLoginResult {
  UserDto user;
  bool isNew;
  GoogleUserLoginResult(this.user, this.isNew);
}

class GoogleUserDTO {
  final String id;
  final String displayName;
  final String email;
  final String? photoUrl;

  GoogleUserDTO({
    required this.id,
    required this.displayName,
    required this.email,
    this.photoUrl,
  });

  @override
  String toString() {
    return 'GoogleUserDTO(id: $id, displayName: $displayName, email: $email, photoUrl: $photoUrl)';
  }
}