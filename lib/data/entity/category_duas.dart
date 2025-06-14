import 'package:drift/drift.dart';

class CategoryDuas extends Table {
  IntColumn get id => integer()();
  TextColumn get name => text()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
