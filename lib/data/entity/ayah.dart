import 'package:drift/drift.dart';
import 'package:mtqmnuns/data/entity/surah.dart';

class Ayah extends Table {
  IntColumn get id => integer()();
  IntColumn get surahId => integer().references(Surah, #id)();
  TextColumn get ayahText => text()();
  TextColumn get indoText => text()();
  TextColumn get readText => text()();
  IntColumn get juz => integer()();
  IntColumn get ayahNumber => integer()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

