import 'package:flutter/material.dart';
import 'package:mtqmnuns/config/Global.dart';
import 'package:mtqmnuns/repositories/surah.dart';
import 'package:mtqmnuns/state/surah.dart';

class SurahDetailViewModel extends ChangeNotifier {
  final SurahRepository _surahRepo;
  SurahDetailViewModel(this._surahRepo);
  int? previousSurahId;
  SurahDetailState state = SurahLoading();

  Future<void> loadSurah(int? surahId) async {
    state = SurahLoading();
    notifyListeners();
    if (surahId == null) {
      state = SurahError('id not found(500)');
      notifyListeners();
      return;
    }
    try {
      final data = await _surahRepo.getSurahWithAyahs(surahId);
      final quranMode = GlobalConfig().quranMode;
      state = SurahSuccess(data, quranMode);
      previousSurahId = surahId;
    } catch (e) {
      state = SurahError(e.toString());
    }
    notifyListeners();
  }
}
