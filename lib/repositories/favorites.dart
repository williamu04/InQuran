import 'package:mtqmnuns/data/local/cache/favorites.dart';
import 'package:mtqmnuns/data/remote/favorites.dart';
import 'package:mtqmnuns/dto/favorites.dart';

class FavoritesRepository {
  final FavoritesDataSource remoteDataSource;

  FavoritesRepository(this.remoteDataSource);

  Future<List<FavoriteDto>> getAll(String accessToken) async {
    final favorites = await remoteDataSource.getAllFavorites(accessToken);
    await FavoriteCache.saveFavorite(favorites);
    return favorites;
  }

  Future<List<FavoriteDto>> add(String accessToken, FavoriteDto favorite) async {
    final favorites = await remoteDataSource.addFavorite(accessToken, favorite);
    await FavoriteCache.saveFavorite(favorites);
    return favorites;
  }

  Future<List<FavoriteDto>> delete(String accessToken, FavoriteDto favorite) async {
    final favorites = await remoteDataSource.deleteFavorite(accessToken, favorite);
    await FavoriteCache.saveFavorite(favorites);
    return favorites;
  }

  Future<List<FavoriteDto>?> loadFromCache() async {
    return FavoriteCache.loadFavorite();
  }
}
