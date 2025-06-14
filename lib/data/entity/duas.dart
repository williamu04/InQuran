import 'package:drift/drift.dart';
import 'package:mtqmnuns/data/entity/category_duas.dart';

class Duas extends Table {
  IntColumn get id => integer()();
  IntColumn get categoryId => integer().references(CategoryDuas, #id)();
  TextColumn get title => text()();
  TextColumn get doaArab => text()();
  TextColumn get doaLatin => text()();
  TextColumn get doaIndo => text()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

