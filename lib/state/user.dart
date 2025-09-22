import 'package:mtqmnuns/dto/user.dart';

sealed class UserLoadState {}

class UserLoadLoading extends UserLoadState {}

class UserLoadUnauthenticated extends UserLoadState {}

class UserLoadError extends UserLoadState {
  final String message;
  UserLoadError(this.message);
}

class UserLoaded extends UserLoadState {
  final UserDto user;
  UserLoaded(this.user);
}
