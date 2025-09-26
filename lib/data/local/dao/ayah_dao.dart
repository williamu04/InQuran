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

  Future<List<AyahWithSurah>> getAyahWithSurahByJuz(int juzNumber) async {
    final query = select(surah).join([
      innerJoin(ayah, ayah.surahId.equalsExp(surah.id)),
    ])
      ..where(ayah.juz.equals(juzNumber)); 

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

  Future<List<AyahWithSurah>> getAyahsByPage(int pageNumber) async {
    final query = select(surah).join([
      innerJoin(ayah, ayah.surahId.equalsExp(surah.id)),
    ])
      ..where(ayah.page.equals(pageNumber))
      ..orderBy([
        OrderingTerm(expression: surah.id),
        OrderingTerm(expression: ayah.ayahNumber),
      ]);

    final rows = await query.get();

    return rows.map((row) {
      return AyahWithSurah(
        surah: row.readTable(surah),
        ayah: row.readTable(ayah),
      );
    }).toList();
  }

  Future<List<AyahWithSurah>> getPageBySurahAndAyah(int surahId, int ayahNumber) async {
    final pageRow = await (selectOnly(ayah)
          ..addColumns([ayah.page])
          ..where(ayah.surahId.equals(surahId) & ayah.ayahNumber.equals(ayahNumber)))
        .getSingleOrNull();

    if (pageRow == null) {
      return [];
    }

    final page = pageRow.read(ayah.page);

    if (page == null) {
      return [];
    }

    final query = select(surah).join([
      innerJoin(ayah, ayah.surahId.equalsExp(surah.id)),
    ])
      ..where(ayah.page.equals(page))
      ..orderBy([
        OrderingTerm(expression: surah.id),
        OrderingTerm(expression: ayah.ayahNumber),
      ]);

    final rows = await query.get();

    return rows.map((row) {
      return AyahWithSurah(
        surah: row.readTable(surah),
        ayah: row.readTable(ayah),
      );
    }).toList();
  }


  Future<List<AyahWithSurah>> getFirstPageByJuz(int juzNumber) async {
    final firstPageRow = await (selectOnly(ayah)
          ..addColumns([ayah.page.min()])
          ..where(ayah.juz.equals(juzNumber)))
        .getSingle();

    final firstPage = firstPageRow.read(ayah.page.min());
    if (firstPage == null) return [];

    return getAyahsByPage(firstPage);
  }

}

