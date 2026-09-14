import 'package:inquran/repositories/search.dart';
import 'package:inquran/services/ayah_search.dart';
import 'package:inquran/state/search.dart';
import 'package:inquran/state/stateful_viewmodel.dart';

class SearchViewModel extends StatefulViewModel<SearchState> {
  final SearchRepository _repo;
  final AyahSearchService _service;

  SearchViewModel(this._repo, this._service) : super(SearchIdle());

  SearchMode _mode = SearchMode.specific;
  SearchMode get mode => _mode;

  String _query = '';
  int _runId = 0;

  Future<void> updateQuery(String query) async {
    final normalized = _service.normalizeQuery(query);
    if (normalized == _query) return;
    _query = normalized;
    await _runSearch();
  }

  Future<void> setMode(SearchMode mode) async {
    if (_mode == mode) return;
    _mode = mode;
    await _runSearch();
  }

  void clear() {
    _query = '';
    setState(SearchIdle());
  }

  Future<void> _runSearch() async {
    final query = _query;
    final mode = _mode;

    if (query.isEmpty) {
      setState(SearchIdle());
      return;
    }

    final runId = ++_runId;
    setState(SearchLoading(query, mode));

    try {
      final result = await _repo.search(query: query, mode: mode);
      if (runId != _runId) return;

      if (result.totalCount == 0) {
        setState(SearchEmpty(query, mode));
      } else {
        setState(
          SearchLoaded(
            query,
            mode,
            result.ayahs,
            result.totalCount,
            _highlightTerms(query, mode),
          ),
        );
      }
    } catch (e) {
      if (runId != _runId) return;
      setState(SearchError("Gagal mencari ayat: $e"));
    }
  }

  List<String> _highlightTerms(String query, SearchMode mode) {
    switch (mode) {
      case SearchMode.specific:
        return [query];
      case SearchMode.approach:
        return _service.tokenize(query);
    }
  }
}
