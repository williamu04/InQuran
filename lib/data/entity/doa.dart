import 'package:drift/drift.dart';
import 'package:inquran/data/entity/ayah.dart';
import 'package:inquran/data/entity/doa_category.dart';

class Doa extends Table {
  IntColumn get id => integer()();
  IntColumn get categoryId => integer().references(DoaCategory, #id)();
  IntColumn get ayahId => integer().references(Ayah, #id)();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
