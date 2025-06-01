import 'package:drift/drift.dart';
import 'package:mtqmnuns/data/entity/ayah.dart';
import 'package:mtqmnuns/data/local/db/app_database.dart'; 

part 'ayah_dao.g.dart';

@DriftAccessor(tables: [Ayah])
class AyahDao extends DatabaseAccessor<AppDatabase> with _$AyahDaoMixin {
  AyahDao(AppDatabase db) : super(db);

  Future<List<AyahData>> getAllAyahs() => select(ayah).get();

  Future<List<AyahData>> getAyahsBySurahId(int surahId) {
    return (select(ayah)..where((tbl) => tbl.surahId.equals(surahId))).get();
  }
}

