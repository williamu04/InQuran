
import 'dart:math';

import 'package:fuzzywuzzy/fuzzywuzzy.dart';
import 'package:mtqmnuns/data/local/dao/surah_dao.dart';
import 'package:mtqmnuns/data/local/db/app_database.dart';
import 'package:mtqmnuns/dto/surah.dart';

class SurahRepository {
  final SurahDao _surahDao;

  SurahRepository(this._surahDao);



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