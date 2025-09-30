
import 'package:mtqmnuns/dto/favorites.dart';

sealed class FavoritesLoadState {}

class FavoritesLoadLoading extends FavoritesLoadState {}

class FavoritesLoadUnauthenticated extends FavoritesLoadState {}

class FavoritesLoadError extends FavoritesLoadState {
  String message;
  FavoritesLoadError(this.message);
}

class FavoritesLoaded extends FavoritesLoadState {
  final List<FavoriteDto> favorites;
  FavoritesLoaded(this.favorites);
}

class FavoritesLoadedOffline extends FavoritesLoaded {
  FavoritesLoadedOffline(super.favorites);
}
