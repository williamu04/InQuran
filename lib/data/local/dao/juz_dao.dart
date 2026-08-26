import 'package:drift/drift.dart';
import 'package:inquran/data/entity/ayah.dart';
import 'package:inquran/data/local/db/app_database.dart';
import 'package:inquran/data/aggregate/juz.dart'; 

part 'juz_dao.g.dart';

@DriftAccessor(tables: [Ayah])
class JuzDao extends DatabaseAccessor<AppDatabase> with _$JuzDaoMixin {
  JuzDao(super.db);

  Future<JuzInfo?> getJuzInfo(int juzNumber) async {
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

      if (firstResult == null || lastResult == null) return null;

      return JuzInfo(
        juzNumber: juzNumber,
        startAyah: firstResult.readTable(ayah),
        startSurah: firstResult.readTable(surah),
        endAyah: lastResult.readTable(ayah),
        endSurah: lastResult.readTable(surah),
      );

    }

}
