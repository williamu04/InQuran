import 'package:drift/drift.dart';
import 'package:mtqmnuns/data/entity/ayah.dart';
import 'package:mtqmnuns/data/local/db/app_database.dart';
import 'package:mtqmnuns/data/entity/surah.dart';
import 'package:mtqmnuns/data/aggregate/surah.dart';

part 'surah_dao.g.dart';

@DriftAccessor(tables: [Surah, Ayah])
class SurahDao extends DatabaseAccessor<AppDatabase> with _$SurahDaoMixin {
  SurahDao(super.db);

  Future<List<SurahData>> getAllSurahs() => select(surah).get();

  Future<SurahData?> getSurahById(int id) =>(
      select(surah)..where((tbl) => tbl.id.equals(id))
    ).getSingleOrNull();

  Future<SurahWithAyahs> getSurahWithAyahs(int id) async {
    final surahQuery = select(surah)..where((tbl) => tbl.id.equals(id));
    final surahData = await surahQuery.getSingleOrNull();
    
    
    final ayahsQuery = select(ayah)
      ..where((tbl) => tbl.surahId.equals(id))
      ..orderBy([(tbl) => OrderingTerm.asc(tbl.ayahNumber)]);
    
    final ayahs = await ayahsQuery.get();
    return SurahWithAyahs(surahData, ayahs);
  }

  Future<List<SurahWithAyahs>> getAllSurahWithAyahs() async {
    final rows = await (select(surah).join([
      leftOuterJoin(ayah, ayah.surahId.equalsExp(surah.id))
    ])
      ..orderBy([
        OrderingTerm.asc(surah.id),
        OrderingTerm.asc(ayah.ayahNumber),
      ])
    ).get();

    final grouped = <int, SurahWithAyahs>{};

    for (final row in rows) {
      final s = row.readTable(surah);
      final a = row.readTableOrNull(ayah);

      grouped.putIfAbsent(s.id, () => SurahWithAyahs(s, []));
      if (a != null) grouped[s.id]!.ayahs.add(a);
    }

    return grouped.values.toList();
  }

}
