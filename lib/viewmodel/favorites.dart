import 'package:mtqmnuns/data/local/cache/favorites.dart';
import 'package:mtqmnuns/dto/favorites.dart';
import 'package:mtqmnuns/state/favorites.dart';
import 'package:mtqmnuns/state/success_or_fail.dart';
import 'package:mtqmnuns/viewmodel/stateful_generic_helper.dart';

class FavoritesViewModel extends StatefulViewModel<FavoritesLoadState> {
  FavoritesViewModel() : super(FavoritesLoadLoading());

  List<FavoriteDto> _favorites = [];

  /// Load favorites from the local cache (fully offline).
  Future<void> getAllFavorites() async {
    try {
      _favorites = await FavoriteCache.loadFavorite() ?? [];
      setState(FavoritesLoaded(_favorites));
    } catch (e) {
      setState(FavoritesLoadError(e.toString()));
    }
  }

  Future<SuccessOrFail> addFavorite(FavoriteDto favorite) async {
    try {
      final exists = _favorites.any(
        (f) =>
            f.surahNumber == favorite.surahNumber &&
            f.ayahNumber == favorite.ayahNumber,
      );
      if (!exists) {
        _favorites = [..._favorites, favorite];
        await FavoriteCache.saveFavorite(_favorites);
      }
      setState(FavoritesLoaded(_favorites));
      return Success("OK");
    } catch (e) {
      return Failure(e.toString());
    }
  }

  Future<SuccessOrFail> deleteFavorite(FavoriteDto favorite) async {
    try {
      _favorites = _favorites
          .where(
            (f) =>
                f.surahNumber != favorite.surahNumber ||
                f.ayahNumber != favorite.ayahNumber,
          )
          .toList();
      await FavoriteCache.saveFavorite(_favorites);
      setState(FavoritesLoaded(_favorites));
      return Success("OK");
    } catch (e) {
      return Failure(e.toString());
    }
  }
}