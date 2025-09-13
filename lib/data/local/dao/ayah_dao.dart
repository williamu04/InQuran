import 'package:drift/drift.dart';
import 'package:mtqmnuns/data/aggregate/surah.dart';
import 'package:mtqmnuns/data/entity/ayah.dart';
import 'package:mtqmnuns/data/local/db/app_database.dart'; 

part 'ayah_dao.g.dart';

@DriftAccessor(tables: [Ayah])
class AyahDao extends DatabaseAccessor<AppDatabase> with _$AyahDaoMixin {
  AyahDao(super.db);

  Future<List<AyahData>> getAllAyahs() => select(ayah).get();

  Future<List<AyahData>> getAyahsBySurahId(int surahId) {
    return (select(ayah)..where((tbl) => tbl.surahId.equals(surahId))).get();
  }

  Future<List<AyahWithSurah>> getSurahWithAyah() async {
    final query = select(surah).join([
      innerJoin(ayah, ayah.surahId.equalsExp(surah.id)),
    ]);

    final rows = await query.get();

    return rows.map((row) {
      final surahData = row.readTable(surah);
      final ayahData = row.readTable(ayah);

      return AyahWithSurah(
        surah: surahData,
        ayah: ayahData,
      );
    }).toList();
  }

  Future<bool> ayahExists(int surahId, int ayahNumber) async {
    final count = await (selectOnly(ayah)
      ..addColumns([ayah.id.count()])
      ..where(ayah.surahId.equals(surahId) & ayah.ayahNumber.equals(ayahNumber))
    ).getSingle();
    
    return count.read(ayah.id.count()) != null && count.read(ayah.id.count())! > 0;
  }

  Future<List<AyahWithSurah>> getAyahsInLogicalRange(
    int startSurahId, 
    int startAyahNumber, 
    int endSurahId, 
    int endAyahNumber
  ) async {
    final query = select(surah).join([
      innerJoin(ayah, ayah.surahId.equalsExp(surah.id)),
    ]);

    if (startSurahId == endSurahId) {
      query.where(
        ayah.surahId.equals(startSurahId) &
        ayah.ayahNumber.isBiggerOrEqualValue(startAyahNumber) &
        ayah.ayahNumber.isSmallerOrEqualValue(endAyahNumber)
      );
    } else {
      query.where(
        (ayah.surahId.equals(startSurahId) & 
        ayah.ayahNumber.isBiggerOrEqualValue(startAyahNumber)) |
        
        (ayah.surahId.isBiggerThanValue(startSurahId) & 
        ayah.surahId.isSmallerThanValue(endSurahId)) |
        
        (ayah.surahId.equals(endSurahId) & 
        ayah.ayahNumber.isSmallerOrEqualValue(endAyahNumber))
      );
    }

    query.orderBy([
      OrderingTerm(expression: surah.id),
      OrderingTerm(expression: ayah.ayahNumber)
    ]);

    final rows = await query.get();
    return rows.map((row) {
      final surahData = row.readTable(surah);
      final ayahData = row.readTable(ayah);
      return AyahWithSurah(surah: surahData, ayah: ayahData);
    }).toList();
  }


  Future<List<AyahWithSurah>> getAyahWithSurahBySurahId(int surahId) async {
    final query = select(surah).join([
      innerJoin(ayah, ayah.surahId.equalsExp(surah.id)),
    ])
      ..where(surah.id.equals(surahId));

    final rows = await query.get();

    return rows.map((row) {
      final surahData = row.readTable(surah);
      final ayahData = row.readTable(ayah);
      return AyahWithSurah(surah: surahData, ayah: ayahData);
    }).toList();
  }

  Future<List<AyahWithSurah>> getNextAyahsFromPosition(
    int startSurahId, 
    int startAyahNumber, 
    int count
  ) async {
    final query = select(surah).join([
      innerJoin(ayah, ayah.surahId.equalsExp(surah.id)),
    ]);

    query.where(
      (ayah.surahId.equals(startSurahId) & 
      ayah.ayahNumber.isBiggerThanValue(startAyahNumber)) |
      
      ayah.surahId.isBiggerThanValue(startSurahId)
    );

    query
      ..orderBy([
        OrderingTerm(expression: surah.id),
        OrderingTerm(expression: ayah.ayahNumber)
      ])
      ..limit(count);

    final rows = await query.get();
    return rows.map((row) {
      final surahData = row.readTable(surah);
      final ayahData = row.readTable(ayah);
      return AyahWithSurah(surah: surahData, ayah: ayahData);
    }).toList();
  }

  Future<List<AyahWithSurah>> getPreviousAyahsBeforePosition(
    int endSurahId, 
    int endAyahNumber, 
    int count
  ) async {
    final query = select(surah).join([
      innerJoin(ayah, ayah.surahId.equalsExp(surah.id)),
    ]);

    query.where(
      ayah.surahId.isSmallerThanValue(endSurahId) |
      (ayah.surahId.equals(endSurahId) & 
      ayah.ayahNumber.isSmallerThanValue(endAyahNumber))
    );

    query
      ..orderBy([
        OrderingTerm(expression: surah.id, mode: OrderingMode.desc),
        OrderingTerm(expression: ayah.ayahNumber, mode: OrderingMode.desc)
      ])
      ..limit(count);

    final rows = await query.get();
    
    final results = rows.map((row) {
      final surahData = row.readTable(surah);
      final ayahData = row.readTable(ayah);
      return AyahWithSurah(surah: surahData, ayah: ayahData);
    }).toList();
    
    return results.reversed.toList();
  }
}

