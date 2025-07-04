import 'package:drift/drift.dart';
import 'package:mtqmnuns/data/local/db/app_database.dart';
import 'package:mtqmnuns/data/entity/duas.dart';

part 'duas_dao.g.dart';

@DriftAccessor(tables: [Duas])
class DuasDao extends DatabaseAccessor<AppDatabase> with _$DuasDaoMixin {
  DuasDao(super.db);

  Future<List<Dua>> getAllDuas() => select(duas).get();
  Future<List<CategoryDua>> getDuasCategory() => select(categoryDuas).get();

  Future<List<Dua>> getDuasByCategory(int categoryId) {
    return (select(duas)..where((t) => t.categoryId.equals(categoryId))).get();
  }
}
