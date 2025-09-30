import 'package:mtqmnuns/dto/favorites.dart';
import 'package:mtqmnuns/exception/http.dart';
import 'package:mtqmnuns/repositories/favorites.dart';
import 'package:mtqmnuns/state/favorites.dart';
import 'package:mtqmnuns/state/success_or_fail.dart';
import 'package:mtqmnuns/viewmodel/auth.dart';
import 'package:mtqmnuns/viewmodel/stateful_generic_helper.dart';

class FavoritesViewModel extends StatefulViewModel<FavoritesLoadState> {
  final FavoritesRepository _favoritesRepo;
  final AuthViewModel authVm;

  FavoritesViewModel(this._favoritesRepo, this.authVm)
      : super(FavoritesLoadLoading());

  Future<void> getAllFavorites() async {
    if (!authVm.isLoggedIn()) {
      setState(FavoritesLoadUnauthenticated());
      return;
    }

    try {
      final token = await authVm.getValidTokenOrThrow();
      final favs = await _favoritesRepo.getAll(token);
      setState(FavoritesLoaded(favs));
    } catch (e) {
      await _errorFallback(e);
    }
  }

  Future<SuccessOrFail> addFavorite(FavoriteDto favorite) async {
    if (!authVm.isLoggedIn()) {
      setState(FavoritesLoadUnauthenticated());
      return Failure("Unauthenticated, Login untuk mengakses fitur ini");
    }

    try {
      final token = await authVm.getValidTokenOrThrow();
      final updatedFavs = await _favoritesRepo.add(token, favorite);
      setState(FavoritesLoaded(updatedFavs));
      return Success("OK");
    } catch (e) {
      return Failure(e.toString());
    }
  }

  Future<SuccessOrFail> deleteFavorite(FavoriteDto favorite) async {
    if (!authVm.isLoggedIn()) {
      setState(FavoritesLoadUnauthenticated());
      return Failure("Unauthenticated, Login untuk mengakses fitur ini");
    }

    try {
      final token = await authVm.getValidTokenOrThrow();
      final updatedFavs = await _favoritesRepo.delete(token, favorite);
      setState(FavoritesLoaded(updatedFavs));
      return Success("OK");
    } catch (e) {
      return Failure(e.toString());
    }
  }

  Future<void> _errorFallback(Object error) async {
    if (error is RefreshTokenInvalidError) {
      setState(FavoritesLoadUnauthenticated());
      return;
    }

    final cached = await _favoritesRepo.loadFromCache();
    if (cached != null) {
      setState(FavoritesLoadedOffline(cached));
    } else {
      setState(FavoritesLoadError(error.toString()));
    }
  }
}
