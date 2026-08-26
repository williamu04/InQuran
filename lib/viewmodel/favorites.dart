import 'package:inquran/data/local/cache/favorites.dart';
import 'package:inquran/data/local/dao/ayah_dao.dart';
import 'package:inquran/dto/favorites.dart';
import 'package:inquran/state/favorites.dart';
import 'package:inquran/state/success_or_fail.dart';
import 'package:inquran/state/stateful_viewmodel.dart';

class FavoritesViewModel extends StatefulViewModel<FavoritesLoadState> {
  final AyahDao _ayahDao;

  FavoritesViewModel(this._ayahDao) : super(FavoritesLoadLoading());

  List<FavoriteDto> _favorites = [];

  /// Load favorites from the local cache (fully offline).
  Future<void> getAllFavorites() async {
    try {
      _favorites = await FavoriteCache.loadFavorite() ?? [];
      final ayahs = await _ayahDao.getAyahsFromFavorites(_favorites);
      setState(FavoritesLoaded(_favorites, ayahs));
    } catch (e) {
      setState(FavoritesLoadError(e.toString()));
    }
  }

  Future<SuccessOrFail<String>> addFavorite(FavoriteDto favorite) async {
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
      final ayahs = await _ayahDao.getAyahsFromFavorites(_favorites);
      setState(FavoritesLoaded(_favorites, ayahs));
      return Success("OK");
    } catch (e) {
      return Failure(e.toString());
    }
  }

  Future<SuccessOrFail<String>> deleteFavorite(FavoriteDto favorite) async {
    try {
      _favorites = _favorites
          .where(
            (f) =>
                f.surahNumber != favorite.surahNumber ||
                f.ayahNumber != favorite.ayahNumber,
          )
          .toList();
      await FavoriteCache.saveFavorite(_favorites);
      final ayahs = await _ayahDao.getAyahsFromFavorites(_favorites);
      setState(FavoritesLoaded(_favorites, ayahs));
      return Success("OK");
    } catch (e) {
      return Failure(e.toString());
    }
  }
}