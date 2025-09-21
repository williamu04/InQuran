class TokenDto {
  final String sessionId;
  final String jwtToken;
  final String refreshToken;

  TokenDto({required this.sessionId, required this.jwtToken, required this.refreshToken});
}