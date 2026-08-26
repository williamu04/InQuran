import 'package:drift/drift.dart';
import 'package:inquran/data/aggregate/doa.dart';
import 'package:inquran/data/entity/ayah.dart';
import 'package:inquran/data/entity/doa_category.dart';
import 'package:inquran/data/local/db/app_database.dart';
import 'package:inquran/data/entity/doa.dart';

part 'doa_dao.g.dart';

@DriftAccessor(tables: [Doa, DoaCategory, Ayah])
class DoaDao extends DatabaseAccessor<AppDatabase> with _$DoaDaoMixin {
  DoaDao(super.db);

  Future<List<DoaData>> getAllDuas() => select(doa).get();
  Future<List<DoaCategoryData>> getDoaCategories() => select(doaCategory).get();
  Future<List<CompleteDoaData>> getAllCompleteDuas() async {
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

      return CompleteDoaData(doaRow.id, categoryRow, ayahRow, surahRow);
    }).toList();
  }

  Future<List<CompleteDoaData>> getDoasByCategory(int categoryId) async {
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

      return CompleteDoaData(
        doaRow.id,
        categoryRow,
        ayahRow,
        surahRow, // 🔹 include Surah
      );
    }).toList();
  }
}
