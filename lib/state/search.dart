import 'package:inquran/data/aggregate/surah.dart';

enum SearchMode { specific, approach }

sealed class SearchState {}

class SearchIdle extends SearchState {}

class SearchLoading extends SearchState {
  final String query;
  final SearchMode mode;

  SearchLoading(this.query, this.mode);
}

class SearchLoaded extends SearchState {
  final String query;
  final SearchMode mode;
  final List<AyahWithSurah> results;
  final int totalCount;
  final List<String> highlightTerms;

  SearchLoaded(
    this.query,
    this.mode,
    this.results,
    this.totalCount,
    this.highlightTerms,
  );
}

class SearchEmpty extends SearchState {
  final String query;
  final SearchMode mode;

  SearchEmpty(this.query, this.mode);
}

class SearchError extends SearchState {
  final String message;

  SearchError(this.message);
}
