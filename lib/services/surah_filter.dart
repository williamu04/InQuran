import 'package:mtqmnuns/models/juz.dart';
import 'package:mtqmnuns/models/surah.dart';

class SurahFilterService {
  List<SurahWithVerseCount> filterSurahs(List<SurahWithVerseCount> allSurahs, String query) {
    final q = query.toLowerCase().trim();

    return allSurahs.where((surahVerse) {
      final surah = surahVerse.surah;
      return surah.nameLatin.toLowerCase().contains(q) ||
             surah.place.toLowerCase().contains(q) ||
             surah.name.toLowerCase().contains(q) ||
             surah.id.toString().contains(q);
    }).toList();
  }

  List<JuzInfo> filterJuz(List<JuzInfo> allJuz, String query) {
    final q = query.toLowerCase().trim();

    return allJuz.where((juz) {
      final juzLabel = 'juz ${juz.juzNumber}';

      return juz.juzNumber.toString().contains(q) ||
             juzLabel.contains(q) ||
             _surahMatches(juz.startSurah, q) ||
             _surahMatches(juz.endSurah, q);
    }).toList();
  }

  bool _surahMatches(dynamic surahData, String query) {
    if (surahData == null) return false;

    final nameLatin = (surahData.nameLatin ?? '').toLowerCase();
    final nameArabic = (surahData.name ?? '').toLowerCase();

    return nameLatin.contains(query) || nameArabic.contains(query);
  }
}
