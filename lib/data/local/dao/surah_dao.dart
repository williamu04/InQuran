import 'dart:math';

import 'package:drift/drift.dart';
import 'package:fuzzywuzzy/fuzzywuzzy.dart';
import 'package:mtqmnuns/data/entity/ayah.dart';
import 'package:mtqmnuns/data/local/db/app_database.dart';
import 'package:mtqmnuns/data/entity/surah.dart';
import 'package:mtqmnuns/models/surah.dart';

part 'surah_dao.g.dart';

@DriftAccessor(tables: [Surah, Ayah])
class SurahDao extends DatabaseAccessor<AppDatabase> with _$SurahDaoMixin {
  SurahDao(AppDatabase db) : super(db);

  Future<List<SurahData>> getAllSurahs() => select(surah).get();

  Future<SurahData?> getSurahById(int id) =>
      (select(surah)..where((tbl) => tbl.id.equals(id))).getSingleOrNull();

  Future<SurahData?> fuzzyFindSurahFromText(String input) async {
    await Future.delayed(const Duration(milliseconds: 300)); 

    final tokens = input.toLowerCase().split(RegExp(r'\s+'));

    SurahData? bestMatch;
    int bestScore = 0;

    final allSurahs = await getAllSurahs();

    for (var surah in allSurahs) {
      final surahName = surah.nameLatin.toLowerCase();

      String normalizedSurahName = surahName
          .replaceAll(RegExp(r'\bal[\s-]'), 'al')
          .replaceAll(RegExp(r'\ban[\s-]'), 'an')
          .replaceAll(RegExp(r'\bat[\s-]'), 'at')
          .replaceAll(RegExp(r'\bas[\s-]'), 'as')
          .replaceAll(RegExp(r'\basy[\s-]'), 'asy')
          .replaceAll(RegExp(r'\bar[\s-]'), 'ar')
          .replaceAll(RegExp(r'\bad[\s-]'), 'ad')
          .replaceAll(RegExp(r'\baz[\s-]'), 'az');

      int maxTokenScore = 0;

      for (var token in tokens) {
        if (token.length <= 2) continue;

        int tokenScore = ratio(token, normalizedSurahName);

        if (normalizedSurahName.contains(token) && token.length >= 4) {
          tokenScore = max(tokenScore, 85);
        }

        if (tokenScore > maxTokenScore) {
          maxTokenScore = tokenScore;
        }
      }

      if (maxTokenScore > bestScore) {
        bestScore = maxTokenScore;
        bestMatch = surah;
      }
    }

    return bestScore >= 70 ? bestMatch : null;
  }

  Future<List<SurahWithVerse>> getAllSurahsWithVerseCount() async {
    final countExp = ayah.id.count();

    final query = (select(surah)
          ..orderBy([(s) => OrderingTerm.asc(s.id)]))
        .join([
          leftOuterJoin(
            ayah,
            ayah.surahId.equalsExp(surah.id),
          )
        ])
        ..addColumns([countExp])
        ..groupBy([surah.id]);

    final rows = await query.get();

    return rows.map((row) {
      final surahData = row.readTable(surah);
      final count = row.read(countExp) ?? 0;
      return SurahWithVerse(surahData, count);
    }).toList();
  }
  Future<SurahWithAyahs?> getSurahWithAyahs(int id) async {
    final surahQuery = select(surah)..where((tbl) => tbl.id.equals(id));
    final surahData = await surahQuery.getSingleOrNull();
    
    if (surahData == null) return null;
    
    final ayahsQuery = select(ayah)
      ..where((tbl) => tbl.surahId.equals(id))
      ..orderBy([(tbl) => OrderingTerm.asc(tbl.ayahNumber)]);
    
    final ayahs = await ayahsQuery.get();
    return ayahs.isEmpty ? null : SurahWithAyahs(surahData, ayahs);
  }
}
