import 'package:mtqmnuns/dto/user.dart';

sealed class UserLoadState {}

class UserLoadLoading extends UserLoadState {}

class UserLoadUnauthenticated extends UserLoadState {}

class UserLoadSessionExpired extends UserLoadState {}

class UserLoaded extends UserLoadState {
  final UserDto user;
  UserLoaded(this.user);
}
