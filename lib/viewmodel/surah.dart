import 'package:flutter/material.dart';
import 'package:mtqmnuns/data/local/dao/surah_dao.dart';
import 'package:mtqmnuns/models/surah.dart';

class SurahDetailViewModel extends ChangeNotifier {
  final SurahDao _surahDao;
  SurahDetailViewModel(this._surahDao);

  bool isLoading = false;
  String? errorMessage;
  SurahWithAyahs? surahWithAyahs;

  Future<void> loadSurah(int surahId) async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      surahWithAyahs = await _surahDao.getSurahWithAyahs(surahId);

      if (surahWithAyahs?.surah == null || surahWithAyahs?.ayahs == null || surahWithAyahs!.ayahs.isEmpty) {
        errorMessage = 'No Ayahs found for Surah $surahId';
      }
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
