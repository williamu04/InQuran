import 'package:flutter/material.dart';
import 'package:mtqmnuns/dto/surah.dart';
import 'package:mtqmnuns/repositories/ayah.dart';
import 'package:mtqmnuns/state/surah.dart';
import 'package:mtqmnuns/viewmodel/stateful_generic_helper.dart';


class SurahDetailViewModel extends StatefulViewModel<SurahDetailState> {
  final AyahRepository _ayahRepo;

  SurahDetailViewModel(this._ayahRepo) : super(SurahLoading());

  Future<T?> _withSuccess<T>(
    Future<T> Function(List<AyahWithSurahDto> ayahs) action,
  ) async {
    if (state is! SurahSuccess) return null;
    final ayahs = (state as SurahSuccess).ayahs;
    try {
      return await action(ayahs);
    } catch (e) {
      debugPrint(e.toString());
      setState(SurahSuccess(ayahs, warning: "Load Failed"));
      return null;
    }
  }

  void _updateSuccess(List<AyahWithSurahDto> ayahs,
      {String? warning, int? jumpIndex}) {
    setState(SurahSuccess(ayahs, warning: warning, jumpIndex: jumpIndex));
  }

  Future<void> loadSurah(
    int startSurahId,
    int startSurahAyah,
    int endSurahId,
    int endSurahAyah,
  ) async {
    setState(SurahLoading());
    try {
      final data = await _ayahRepo.getAyahsInRange(
        startSurahId: startSurahId,
        startAyahNumber: startSurahAyah,
        endSurahId: endSurahId,
        endAyahNumber: endSurahAyah,
      );
      _updateSuccess(data);
    } catch (e) {
      setState(SurahError(e.toString()));
    }
  }

  Future<void> appendBySurah() async {
    await _withSuccess((ayahs) async {
      final last = ayahs.lastOrNull;
      if (last == null) {
        setState(SurahError("Internal Error(500)"));
        return;
      }
      if (last.surahNumber == 114) return;
      final newAyahs = await _ayahRepo.getAyahsBySurahId(last.surahNumber + 1);
      _updateSuccess([...ayahs, ...newAyahs], jumpIndex: ayahs.length - 1);
    });
  }

  Future<void> preppendBySurah() async {
    await _withSuccess((ayahs) async {
      final first = ayahs.firstOrNull;
      if (first == null) {
        setState(SurahError("Internal Error(500)"));
        return;
      }
      if (first.surahNumber == 1) return;
      final newAyahs =
          await _ayahRepo.getAyahsBySurahId(first.surahNumber - 1);
      _updateSuccess([...newAyahs, ...ayahs], jumpIndex: newAyahs.length);
    });
  }

  Future<void> appendByJuz() async {
    await _withSuccess((ayahs) async {
      final last = ayahs.lastOrNull;
      if (last == null) {
        setState(SurahError("Internal Error(500)"));
        return;
      }
      if (last.juzNumber == 30) return;
      final newAyahs = await _ayahRepo.getAyahsByJuz(last.juzNumber + 1);
      _updateSuccess([...ayahs, ...newAyahs], jumpIndex: ayahs.length - 1);
    });
  }

  Future<void> preppendByJuz() async {
    await _withSuccess((ayahs) async {
      final first = ayahs.firstOrNull;
      if (first == null) {
        setState(SurahError("Internal Error(500)"));
        return;
      }
      if (first.juzNumber == 1) return;
      final newAyahs = await _ayahRepo.getAyahsByJuz(first.juzNumber - 1);
      _updateSuccess([...newAyahs, ...ayahs], jumpIndex: newAyahs.length);
    });
  }

  Future<void> appendSurahByCount(int count) async {
    await _withSuccess((ayahs) async {
      final first = ayahs.firstOrNull;
      if (first == null) {
        setState(SurahError("Internal Error(500)"));
        return;
      }
      if (first.surahNumber == 1) return;
      final newAyahs = await _ayahRepo.getPreviousAyahs(
        endSurahId: first.surahNumber,
        endAyahNumber: first.number,
        count: count,
      );
      _updateSuccess([...newAyahs, ...ayahs], jumpIndex: ayahs.length - 1);
    });
  }

  Future<void> prependSurahByCount(int count) async {
    await _withSuccess((ayahs) async {
      final last = ayahs.lastOrNull;
      if (last == null) {
        setState(SurahError("Internal Error(500)"));
        return;
      }
      if (last.surahNumber == 114) return;
      final newAyahs = await _ayahRepo.getNextAyahs(
        startSurahId: last.surahNumber,
        startAyahNumber: last.number,
        count: count,
      );
      _updateSuccess([...ayahs, ...newAyahs], jumpIndex: newAyahs.length);
    });
  }

  Future<void> loadAllAyahs() async {
    setState(SurahLoading());
    try {
      final data = await _ayahRepo.getAllAyahWithSurah();
      _updateSuccess(data);
    } catch (e) {
      setState(SurahError(e.toString()));
    }
  }
  
}
