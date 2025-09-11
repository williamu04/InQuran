import 'package:drift/drift.dart';
import 'package:mtqmnuns/data/entity/doa_category.dart';
import 'package:mtqmnuns/data/local/db/app_database.dart';
import 'package:mtqmnuns/data/entity/doa.dart';

part 'duas_dao.g.dart';

@DriftAccessor(tables: [Doa, DoaCategory])
class DuasDao extends DatabaseAccessor<AppDatabase> with _$DuasDaoMixin {
  DuasDao(super.db);

  Future<List<DoaData>> getAllDuas() => select(doa).get();
  Future<List<DoaCategoryData>> getDuasCategory() => select(doaCategory).get();
}
