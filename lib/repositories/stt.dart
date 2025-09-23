
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:fuzzywuzzy/fuzzywuzzy.dart';
import 'package:mtqmnuns/common/navigation.dart';
import 'package:mtqmnuns/data/local/dao/surah_dao.dart';
import 'package:mtqmnuns/data/local/db/app_database.dart';
import 'package:mtqmnuns/dto/surah.dart';

class SttRepository {
  final SurahDao _surahDao;

  // klo misal mau tambah dao yang lain :
  //   final AyahDao _ayahDao

  SttRepository(
    this._surahDao,
    // this._ayahDao 
  );

  // terus di main.dart cari line ini : 
  // Provider(create: (context) => SttRepository(
  //       context.read<SurahDao>(), 
  //       context.read<AyahDao>(), <- tambah daonya kayak gini
  //       ....
      
  //     ),
  //   ),

  Future<void Function(BuildContext context)> processTranscription(String input) async {
    final surah = await fuzzyFindSurahFromText(input);
    if (surah != null) {
      return (context) => navigateToSurah(context, surah);
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
}