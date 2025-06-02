import 'package:drift/drift.dart';
import 'package:mtqmnuns/data/entity/ayah.dart';
import 'package:mtqmnuns/data/local/dao/surah_dao.dart';
import 'package:mtqmnuns/data/local/db/app_database.dart'; 

part 'juz_dao.g.dart';

@DriftAccessor(tables: [Ayah])
class JuzDao extends DatabaseAccessor<AppDatabase> with _$JuzDaoMixin {
  JuzDao(super.db);

  Future<List<Map<String, AyahData>>> getJuzBoundaries() async {
    final result = <Map<String, AyahData>>[];

    for (int i = 1; i <= 30; i++) {
      // Get all ayahs for the current juz, ordered by id
      final ayahs = await (select(ayah)
            ..where((tbl) => tbl.juz.equals(i))
            ..orderBy([(tbl) => OrderingTerm(expression: tbl.id)]))
          .get();

      if (ayahs.isEmpty) continue;

      // First and last ayahs for the juz
      final firstAyah = ayahs.first;
      final lastAyah = ayahs.last;

      result.add({'start': firstAyah, 'end': lastAyah});
    }

    return result;
  }


  Future<List<Map<String, dynamic>>> getJuzInfo(SurahDao surahDao) async {
    final boundaries = await getJuzBoundaries();
    final result = <Map<String, dynamic>>[];

    for (int i = 0; i < boundaries.length; i++) {
      final start = boundaries[i]['start']!;
      final end = boundaries[i]['end']!;

      final startSurah = await surahDao.getSurahById(start.surahId);
      final endSurah = await surahDao.getSurahById(end.surahId);

      result.add({
        'juz': i + 1,
        'startAyah': start,
        'startSurah': startSurah,
        'endAyah': end,
        'endSurah': endSurah,
      });
    }

    return result;
  }
}
