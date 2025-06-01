import 'package:drift/drift.dart';
import 'package:mtqmnuns/data/local/db/app_database.dart';
import 'package:mtqmnuns/data/entity/surah.dart';

part 'surah_dao.g.dart';

@DriftAccessor(tables: [Surah])
class SurahDao extends DatabaseAccessor<AppDatabase> with _$SurahDaoMixin {
  SurahDao(AppDatabase db) : super(db);

  Future<List<SurahData>> getAllSurahs() => select(surah).get();

  Future<SurahData?> getSurahById(int id) =>
      (select(surah)..where((tbl) => tbl.id.equals(id))).getSingleOrNull();

}
