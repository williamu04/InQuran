import 'package:flutter/material.dart';
import 'package:mtqmnuns/repositories/ayah.dart';
import 'package:mtqmnuns/state/surah.dart';


class SurahDetailViewModel extends ChangeNotifier {
  final AyahRepository _ayahRepo;

  SurahDetailViewModel(this._ayahRepo);

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
      final data = await _ayahRepo.getAyahsBySurahId(surahId);
      state = SurahSuccess(data);
    } catch (e) {
      state = SurahError(e.toString());
    }
    notifyListeners();
  }

  Future<void> appendBySurah() async {
    switch (state) {
      case SurahSuccess(:final ayahs):
        try {
          final last = ayahs.isNotEmpty ? ayahs.last : null;
          if (last == null) {
            state = SurahError("Internal Error(500)");
            notifyListeners();
            return;
          }
          if (last.surahNumber == 114) return; 
          final newAyahs = await _ayahRepo.getAyahsBySurahId(last.surahNumber + 1);
          state = SurahSuccess([...ayahs , ...newAyahs]); 
          notifyListeners();
          return;

        } catch (e) {
          debugPrint(e.toString());
          state = SurahSuccess(ayahs, warning: "Load Failed");
          notifyListeners();
          return;
        }
      default:
        return; 
    }
  }

  Future<int> preppendBySurah() async {
    switch (state) {
      case SurahSuccess(:final ayahs):
        try {
          final first = ayahs.isNotEmpty ? ayahs.first : null;
          if (first == null) {
            state = SurahError("Internal Error(500)");
            notifyListeners();
            return 0;
          }
          if (first.surahNumber == 1) return 0; 
          final newAyahs = await _ayahRepo.getAyahsBySurahId(first.surahNumber - 1);
          state = SurahSuccess([...newAyahs, ...ayahs]); 
          notifyListeners();
          return newAyahs.length;

        } catch (e) {
          debugPrint(e.toString());
          state = SurahSuccess(ayahs, warning: "Load Failed");
          notifyListeners();
          return 0;
        }
      default:
        return 0; 
    }
  }

  Future<void> appendSurahByCount( int count) async {
    switch (state) {
      case SurahSuccess(:final ayahs):
        try {
          final first = ayahs.isNotEmpty ? ayahs.first : null;
          if (first == null) {
            state = SurahError("Internal Error(500)");
            notifyListeners();
            return;
          }
          if (first.surahNumber == 1) return; 
          final newAyahs = await _ayahRepo.getPreviousAyahs(endSurahId: first.surahNumber, endAyahNumber: first.number, count: count);
          state = SurahSuccess([...newAyahs, ...ayahs]); 
          notifyListeners();
          return;

        } catch (e) {
          debugPrint(e.toString());
          state = SurahSuccess(ayahs, warning: "Load Failed");
          notifyListeners();
          return;
        }
      default:
        return; 
    }
  }
  
  Future<void> prependSurahByCount(int count) async {
    switch (state) {
      case SurahSuccess(:final ayahs):
        try {
          final last = ayahs.isNotEmpty ? ayahs.last : null;
          if (last == null) {
            state = SurahError("Internal Error(500)");
            notifyListeners();
            return;
          } 
          if (last.surahNumber == 114) return;
          debugPrint('${last.number} ${last.surahNumber}');
          final newAyahs = await _ayahRepo.getNextAyahs(startSurahId: last.surahNumber, startAyahNumber: last.number, count: count);
          state = SurahSuccess([...ayahs, ...newAyahs]);
          notifyListeners();
          return;
        } catch (e) {
          state = SurahSuccess(ayahs, warning: "Load Failed");
          notifyListeners();
          return;
        }
      default:
        return; 
    }
  }


  Future<void> loadAllSurah() async {
    state = SurahLoading();
    notifyListeners();
    try {
      final data = await _ayahRepo.getAllAyahWithSurah();
      state = SurahSuccess(data);
    } catch (e) {
      state = SurahError(e.toString());
    }
    notifyListeners();
  }
}
