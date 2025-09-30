import 'package:mtqmnuns/dto/user.dart';

sealed class UserLoadState {}

class UserLoadLoading extends UserLoadState {}

class UserLoadUnauthenticated extends UserLoadState {}

class UserLoadError extends UserLoadState{
  String message;
  UserLoadError(this.message);
}

class UserLoadSessionExpired extends UserLoadUnauthenticated{}

class UserLoaded extends UserLoadState {
  final UserDto user;
  UserLoaded(this.user);
}

class UserLoadedOffline extends UserLoaded {
  UserLoadedOffline(super.user);
}