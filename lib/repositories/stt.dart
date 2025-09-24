import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:fuzzywuzzy/fuzzywuzzy.dart';
import 'package:mtqmnuns/common/navigation.dart';
import 'package:mtqmnuns/data/local/dao/surah_dao.dart';
import 'package:mtqmnuns/data/local/dao/duas_dao.dart';
import 'package:mtqmnuns/data/local/db/app_database.dart';
import 'package:mtqmnuns/dto/surah.dart';

class SttRepository {
  final SurahDao _surahDao;
  final DuasDao _duasDao;

  // klo misal mau tambah dao yang lain :
  //   final AyahDao _ayahDao

  SttRepository(
    this._surahDao,
    this._duasDao,
    // this._ayahDao
  );

  // terus di main.dart cari line ini :
  // Provider(create: (context) => SttRepository(
  //       context.read<SurahDao>(),
  //       context.read<AyahDao>(), <- tambah daonya kayak gini
  //       ....

  //     ),
  //   ),

  Future<void Function(BuildContext context)> processTranscription(
    String input,
  ) async {
    final surah = await fuzzyFindSurahFromText(input);
    if (surah != null) {
      return (context) => navigateToSurah(context, surah);
    }

    final doaCategory = await fuzzyFindDuaCategoryFromText(input);
    if (doaCategory != null) {
      return (context) => navigateToDuaCategory(context, doaCategory);
    }

    if (fuzzyMatchCommand(input, [
      'qibla',
      'kiblat',
      'kompas',
      'kompas qibla',
      'arah kiblat',
    ])) {
      return (context) => navigateToQibla(context);
    }

    if (fuzzyMatchCommand(input, [
      'waktu sholat',
      'jadwal sholat',
      'waktu shalat',
      'jadwal shalat',
      'prayer time',
      'prayer times',
      'jadwal',
      'sholat',
      'waktu',
    ])) {
      return (context) => navigateToPrayer(context);
    }

    throw StateError("Command Tidak Berhasil");
  }

  Future<SurahInfoDto?> fuzzyFindSurahFromText(String input) async {
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
      return null;
    }
  }

  /// Return true if any of the [keywords] fuzzy-match the input.
  bool fuzzyMatchCommand(
    String input,
    List<String> keywords, {
    int threshold = 70,
  }) {
    final normalized = input.toLowerCase();

    int best = 0;
    for (var kw in keywords) {
      final k = kw.toLowerCase();
      // full phrase match
      best = max(best, ratio(normalized, k));

      // token-level match for robustness
      for (var token in normalized.split(RegExp(r'\s+'))) {
        if (token.length <= 2) continue;
        best = max(best, ratio(token, k));
      }
    }

    return best >= threshold;
  }

  /// Find the doa category that best matches the input. Returns null if none found.
  Future<DoaCategoryData?> fuzzyFindDuaCategoryFromText(String input) async {
    final categories = await _duasDao.getDuasCategory();
    final normalized = input.toLowerCase();

    DoaCategoryData? best;
    int bestScore = 0;

    for (var c in categories) {
      final name = c.nama.toLowerCase();
      int score = ratio(normalized, name);

      // also try token-level matching (e.g., user says only the category word)
      for (var token in normalized.split(RegExp(r'\s+'))) {
        if (token.length <= 2) continue;
        score = max(score, ratio(token, name));
      }

      if (score > bestScore) {
        bestScore = score;
        best = c;
      }
    }

    // threshold tuned for category names
    if (best != null && bestScore >= 65) return best;
    return null;
  }
}
