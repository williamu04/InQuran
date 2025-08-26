import 'package:drift/drift.dart';
import 'package:mtqmnuns/data/entity/ayah.dart';
import 'package:mtqmnuns/data/local/db/app_database.dart';
import 'package:mtqmnuns/data/entity/surah.dart';
import 'package:mtqmnuns/models/surah.dart';

part 'surah_dao.g.dart';

@DriftAccessor(tables: [Surah, Ayah])
class SurahDao extends DatabaseAccessor<AppDatabase> with _$SurahDaoMixin {
  SurahDao(AppDatabase db) : super(db);

  Future<List<SurahData>> getAllSurahs() => select(surah).get();

  Future<SurahData?> getSurahById(int id) =>(
      select(surah)..where((tbl) => tbl.id.equals(id))
    ).getSingleOrNull();

  Future<List<SurahWithVerseCount>> getAllSurahsWithVerseCount() async {
    final countExp = ayah.id.count();

    final query = (select(surah)
          ..orderBy([(s) => OrderingTerm.asc(s.id)]))
        .join([
          leftOuterJoin(
            ayah,
            ayah.surahId.equalsExp(surah.id),
          )
        ])
        ..addColumns([countExp])
        ..groupBy([surah.id]);

    final rows = await query.get();

    return rows.map((row) {
      final surahData = row.readTable(surah);
      final count = row.read(countExp) ?? 0;
      return SurahWithVerseCount(surahData, count);
    }).toList();
  }
  Future<SurahWithAyahs?> getSurahWithAyahs(int id) async {
    final surahQuery = select(surah)..where((tbl) => tbl.id.equals(id));
    final surahData = await surahQuery.getSingleOrNull();
    
    if (surahData == null) return null;
    
    final ayahsQuery = select(ayah)
      ..where((tbl) => tbl.surahId.equals(id))
      ..orderBy([(tbl) => OrderingTerm.asc(tbl.ayahNumber)]);
    
    final ayahs = await ayahsQuery.get();
    return ayahs.isEmpty ? null : SurahWithAyahs(surahData, ayahs);
  }
}
