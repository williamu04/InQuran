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
