import 'package:inquran/data/aggregate/surah.dart';
import 'package:inquran/dto/favorites.dart';

sealed class FavoritesLoadState {}

class FavoritesLoadLoading extends FavoritesLoadState {}

class FavoritesLoadError extends FavoritesLoadState {
  final String message;
  FavoritesLoadError(this.message);
}

class FavoritesLoaded extends FavoritesLoadState {
  final List<FavoriteDto> favorites;
  final List<AyahWithSurah> ayahs;
  FavoritesLoaded(this.favorites, this.ayahs);
}