import 'package:drift/drift.dart';

class Surah extends Table {
  IntColumn get id => integer()();
  TextColumn get name => text()();
  TextColumn get nameLatin => text()();
  TextColumn get nameIndo => text()();
  TextColumn get description => text()();
  IntColumn get totalAyah => integer()();
  TextColumn get place => text()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
