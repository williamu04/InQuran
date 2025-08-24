import 'package:drift/drift.dart';
import 'package:mtqmnuns/data/entity/ayah.dart';
import 'package:mtqmnuns/data/local/db/app_database.dart';
import 'package:mtqmnuns/models/juz.dart'; 

part 'juz_dao.g.dart';

@DriftAccessor(tables: [Ayah])
class JuzDao extends DatabaseAccessor<AppDatabase> with _$JuzDaoMixin {
  JuzDao(super.db);

  Future<List<JuzInfo>> getAllJuzInfo() async {
    final result = <JuzInfo>[];
    
    for (int juzNumber = 1; juzNumber <= 30; juzNumber++) {
      final firstAyahQuery = select(ayah).join([
        innerJoin(surah, surah.id.equalsExp(ayah.surahId))
      ])
        ..where(ayah.juz.equals(juzNumber))
        ..orderBy([OrderingTerm.asc(ayah.id)])
        ..limit(1);

      final lastAyahQuery = select(ayah).join([
        innerJoin(surah, surah.id.equalsExp(ayah.surahId))
      ])
        ..where(ayah.juz.equals(juzNumber))
        ..orderBy([OrderingTerm.desc(ayah.id)])
        ..limit(1);

      final firstResult = await firstAyahQuery.getSingleOrNull();
      final lastResult = await lastAyahQuery.getSingleOrNull();

      if (firstResult == null || lastResult == null) continue;

      final juzInfo = JuzInfo(
        juzNumber: juzNumber,
        startAyah: firstResult.readTable(ayah),
        startSurah: firstResult.readTable(surah),
        endAyah: lastResult.readTable(ayah),
        endSurah: lastResult.readTable(surah),
      );

      result.add(juzInfo);
    }

    return result;
  }
}
