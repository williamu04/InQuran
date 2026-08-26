import 'package:inquran/dto/juz.dart';
import 'package:inquran/dto/surah.dart';

class SurahFilterService {
  List<SurahInfoDto> filterSurahs(List<SurahInfoDto> allSurahs, String query) {
    final q = query.toLowerCase().trim();

    return allSurahs.where((surah) {
      return surah.nameLatin.toLowerCase().contains(q) ||
             surah.place.toLowerCase().contains(q) ||
             surah.name.toLowerCase().contains(q) ||
             surah.number.toString().contains(q);
    }).toList();
  }

  List<JuzInfoDto> filterJuz(List<JuzInfoDto> allJuz, String query) {
    final q = query.toLowerCase().trim();

    return allJuz.where((juz) {
      final juzLabel = 'juz ${juz.juzNumber}';

      return juz.juzNumber.toString().contains(q) ||
             juzLabel.toLowerCase().contains(q) ||
             juz.startSurahName.toLowerCase().contains(q) ||
             juz.endSurahName.toLowerCase().contains(q);
    }).toList();
  }

}
