
import 'dart:math';

import 'package:fuzzywuzzy/fuzzywuzzy.dart';
import 'package:mtqmnuns/data/local/dao/juz_dao.dart';
import 'package:mtqmnuns/data/local/dao/surah_dao.dart';
import 'package:mtqmnuns/data/local/db/app_database.dart';
import 'package:mtqmnuns/models/juz.dart';
import 'package:mtqmnuns/models/surah.dart';

class SurahRepository {
  final SurahDao _surahDao;
  final JuzDao _juzDao;

  SurahRepository(this._surahDao, this._juzDao);

  Future<SurahData?> fuzzyFindSurahFromText(String input) async {
    await Future.delayed(const Duration(milliseconds: 300)); 

    final tokens = input.toLowerCase().split(RegExp(r'\s+'));

    SurahData? bestMatch;
    int bestScore = 0;

    final allSurahs = await _surahDao.getAllSurahs();

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

  Future<List<SurahWithVerseCount>> getAllSurahsWithVerseCount() => _surahDao.getAllSurahsWithVerseCount();

  Future<List<JuzInfo>> getAllJuzInfo() => _juzDao.getAllJuzInfo();
}