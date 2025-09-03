
import 'dart:math';

import 'package:fuzzywuzzy/fuzzywuzzy.dart';
import 'package:mtqmnuns/data/local/dao/surah_dao.dart';
import 'package:mtqmnuns/data/local/db/app_database.dart';
import 'package:mtqmnuns/dto/surah.dart';

class SurahRepository {
  final SurahDao _surahDao;

  SurahRepository(this._surahDao);

  Future<SurahInfoDto> fuzzyFindSurahFromText(String input) async {
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

    if (bestMatch != null && bestScore >= 70) {
      return SurahInfoDto.fromEntity(bestMatch);
    } else {
      throw StateError("No match, Try Again");
    }
  }


  Future<SurahWithAyahDto> getSurahWithAyahs(int id) async {
    final surahWithAyahData = await _surahDao.getSurahWithAyahs(id);
    final surah = surahWithAyahData.surah;
    final ayahs = surahWithAyahData.ayahs;

    if (surah == null || ayahs.isEmpty) {
      throw Exception("Surah or ayahs not found for id $id");
    }

    final ayahDtos = surahWithAyahData.ayahs.map((ayah) {
      return AyahWithTranslation(
        ayah.ayahNumber,
        ayah.ayahText,
        ayah.indoText,
      );
    }).toList();

    return SurahWithAyahDto(
      surah.id,
      surah.name,
      surah.nameLatin,
      surah.nameIndo,
      ayahDtos,
    );
  }


  Future<List<SurahInfoDto>> getAllSurahs() async {
    final entities = await _surahDao.getAllSurahs(); // returns List<SurahData>
    return entities.map((e) => SurahInfoDto.fromEntity(e)).toList();
  }
}