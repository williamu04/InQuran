import 'package:drift/drift.dart';
import 'package:mtqmnuns/data/aggregate/doa.dart';
import 'package:mtqmnuns/data/entity/ayah.dart';
import 'package:mtqmnuns/data/entity/doa_category.dart';
import 'package:mtqmnuns/data/local/db/app_database.dart';
import 'package:mtqmnuns/data/entity/doa.dart';

part 'duas_dao.g.dart';

@DriftAccessor(tables: [Doa, DoaCategory, Ayah])
class DuasDao extends DatabaseAccessor<AppDatabase> with _$DuasDaoMixin {
  DuasDao(super.db);

  Future<List<DoaData>> getAllDuas() => select(doa).get();
  Future<List<DoaCategoryData>> getDuasCategory() => select(doaCategory).get();
  Future<List<CompleteDuaData>> getAllCompleteDuas() async {
    final query = select(doa).join([
      innerJoin(doaCategory, doaCategory.id.equalsExp(doa.categoryId)),
      innerJoin(ayah, ayah.id.equalsExp(doa.ayahId)),
    ]);

    final rows = await query.get();

    return rows.map((row) {
      final doaRow = row.readTable(doa);
      final categoryRow = row.readTable(doaCategory);
      final ayahRow = row.readTable(ayah);
      final surahRow = row.readTableOrNull(surah);

      return CompleteDuaData(doaRow.id, categoryRow, ayahRow, surahRow);
    }).toList();
  }

  Future<List<CompleteDuaData>> getDuasByCategory(int categoryId) async {
    final query = select(doa).join([
      innerJoin(doaCategory, doaCategory.id.equalsExp(doa.categoryId)),
      innerJoin(ayah, ayah.id.equalsExp(doa.ayahId)),
      innerJoin(surah, surah.id.equalsExp(ayah.surahId)), // 🔹 join ke surah
    ])..where(doa.categoryId.equals(categoryId));

    final rows = await query.get();

    return rows.map((row) {
      final doaRow = row.readTable(doa);
      final categoryRow = row.readTable(doaCategory);
      final ayahRow = row.readTable(ayah);
      final surahRow = row.readTable(surah);

      return CompleteDuaData(
        doaRow.id,
        categoryRow,
        ayahRow,
        surahRow, // 🔹 include Surah
      );
    }).toList();
  }
}
