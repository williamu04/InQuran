import 'package:inquran/data/aggregate/surah.dart';

class AyahSearchResult {
  final List<AyahWithSurah> ayahs;
  final int totalCount;

  const AyahSearchResult(this.ayahs, this.totalCount);
}
