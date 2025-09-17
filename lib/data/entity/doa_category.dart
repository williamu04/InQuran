import 'package:drift/drift.dart';

class DoaCategory extends Table {
  IntColumn get id => integer()();
  TextColumn get nama => text()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
