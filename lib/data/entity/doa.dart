import 'package:drift/drift.dart';
import 'package:mtqmnuns/data/entity/doa_category.dart';
import 'package:mtqmnuns/data/entity/surah.dart';

class Doa extends Table {
  IntColumn get id => integer()();
  IntColumn get categoryId => integer().references(DoaCategory, #id)();
  IntColumn get surahId => integer().references(Surah, #id)();
  IntColumn get startAyah => integer()(); // mulai dari ayat ke berapa
  IntColumn get endAyah => integer()(); // sampai ayat ke berapa

  @override
  Set<Column<Object>> get primaryKey => {id};
}
