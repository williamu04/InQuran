import 'package:drift/drift.dart';
import 'package:mtqmnuns/data/aggregate/doa.dart';
import 'package:mtqmnuns/data/entity/ayah.dart';
import 'package:mtqmnuns/data/entity/surah.dart';
import 'package:mtqmnuns/data/entity/doa_category.dart';
import 'package:mtqmnuns/data/local/db/app_database.dart';
import 'package:mtqmnuns/data/entity/doa.dart';

part 'duas_dao.g.dart';

@DriftAccessor(tables: [Doa, DoaCategory, Surah, Ayah])
class DuasDao extends DatabaseAccessor<AppDatabase> with _$DuasDaoMixin {
  DuasDao(super.db);

  Future<List<DoaData>> getAllDuas() => select(doa).get();

  Future<List<DoaCategoryData>> getDuasCategory() => select(doaCategory).get();

  Future<List<CompleteDuaData>> getAllCompleteDuas() async {
    final query = select(doa).join([
      innerJoin(doaCategory, doaCategory.id.equalsExp(doa.categoryId)),
      innerJoin(surah, surah.id.equalsExp(doa.surahId)),
    ]);

    final rows = await query.get();

    List<CompleteDuaData> results = [];

    for (final row in rows) {
      final doaRow = row.readTable(doa);
      final categoryRow = row.readTable(doaCategory);
      final surahRow = row.readTable(surah);

      // 🔹 Ambil range ayat
      final ayatList =
          await (select(ayah)..where(
            (tbl) =>
                tbl.surahId.equals(doaRow.surahId) &
                tbl.ayahNumber.isBiggerOrEqualValue(doaRow.startAyah) &
                tbl.ayahNumber.isSmallerOrEqualValue(doaRow.endAyah),
          )).get();

      results.add(
        CompleteDuaData(
          id: doaRow.id,
          doaCategory: categoryRow,
          surah: surahRow,
          ayatList: ayatList,
        ),
      );
    }

    return results;
  }

  Future<List<DoaCategoryData>> getDistinctCategories() async {
    final query = select(
      doa,
    ).join([innerJoin(doaCategory, doaCategory.id.equalsExp(doa.categoryId))]);

    final rows = await query.get();

    // distinct kategori
    final categories =
        rows.map((row) => row.readTable(doaCategory)).toSet().toList();
    return categories;
  }

  Future<List<CompleteDuaData>> getDuasByCategory(int categoryId) async {
    final query = select(doa).join([
      innerJoin(doaCategory, doaCategory.id.equalsExp(doa.categoryId)),
      innerJoin(surah, surah.id.equalsExp(doa.surahId)),
    ])..where(doa.categoryId.equals(categoryId));

    final rows = await query.get();
    List<CompleteDuaData> results = [];

    for (final row in rows) {
      final doaRow = row.readTable(doa);
      final categoryRow = row.readTable(doaCategory);
      final surahRow = row.readTable(surah);

      final ayatList =
          await (select(ayah)..where(
            (tbl) =>
                tbl.surahId.equals(doaRow.surahId) &
                tbl.ayahNumber.isBiggerOrEqualValue(doaRow.startAyah) &
                tbl.ayahNumber.isSmallerOrEqualValue(doaRow.endAyah),
          )).get();

      results.add(
        CompleteDuaData(
          id: doaRow.id,
          doaCategory: categoryRow,
          surah: surahRow,
          ayatList: ayatList,
        ),
      );
    }

    return results;
  }
}
