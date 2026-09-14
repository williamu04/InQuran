import 'package:inquran/data/aggregate/search.dart';
import 'package:inquran/data/local/dao/ayah_dao.dart';
import 'package:inquran/services/ayah_search.dart';
import 'package:inquran/state/search.dart';

class SearchRepository {
  final AyahDao _ayahDao;
  final AyahSearchService _service;

  SearchRepository(this._ayahDao, this._service);

  Future<AyahSearchResult> search({
    required String query,
    required SearchMode mode,
  }) async {
    final normalized = _service.normalizeQuery(query);
    if (normalized.isEmpty) return const AyahSearchResult([], 0);

    switch (mode) {
      case SearchMode.specific:
        final phrase = _service.escapeLike(normalized);
        final rows = await _ayahDao.searchAyahsByPhrase(phrase);
        final count = await _ayahDao.countAyahsByPhrase(phrase);
        return AyahSearchResult(rows, count);
      case SearchMode.approach:
        final tokens = _service
            .tokenize(normalized)
            .map(_service.escapeLike)
            .toList();
        if (tokens.isEmpty) return const AyahSearchResult([], 0);
        final rows = await _ayahDao.searchAyahsByAllTokens(tokens);
        final count = await _ayahDao.countAyahsByAllTokens(tokens);
        return AyahSearchResult(rows, count);
    }
  }
}
