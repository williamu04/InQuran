import 'package:flutter/material.dart';
import 'package:mtqmnuns/dto/surah.dart';
import 'package:mtqmnuns/repositories/ayah.dart';
import 'package:mtqmnuns/services/audio_player.dart';
import 'package:mtqmnuns/state/surah.dart';
import 'package:mtqmnuns/viewmodel/stateful_generic_helper.dart';

class SurahDetailViewModel extends StatefulViewModel<SurahDetailState> {
  final AyahRepository _ayahRepo;
  final AudioPlayerService _audioPlayer = AudioPlayerService();

  SurahDetailViewModel(this._ayahRepo) : super(SurahLoading()) {
    // Listener ketika audio selesai
    _audioPlayer.addPlayerCompleteListener(() {
      onAudioComplete();
    });

    // Listener untuk sinkronisasi status play/pause
    _audioPlayer.addPlayerStateListener((isPlaying) {
      if (state is SurahSuccess) {
        final current = state as SurahSuccess;
        _updateSuccess(
          current.ayahs,
          playingIndex: current.playingIndex,
          isPlaying: isPlaying,
        );
      }
    });
  }

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

  void _updateSuccess(
    List<AyahWithSurahDto> ayahs, {
    String? warning,
    int? jumpIndex,
    int? playingIndex,
    bool? isPlaying,
  }) {
    if (state is SurahSuccess) {
      final currentState = state as SurahSuccess;
      setState(
        currentState.copyWith(
          ayahs: ayahs,
          warning: warning,
          jumpIndex: jumpIndex,
          playingIndex: playingIndex,
          isPlaying: isPlaying ?? currentState.isPlaying,
        ),
      );
    } else {
      setState(
        SurahSuccess(
          ayahs,
          warning: warning,
          jumpIndex: jumpIndex,
          playingIndex: playingIndex,
          isPlaying: isPlaying ?? false,
        ),
      );
    }
  }

  /// Play / Pause / Resume ayat tertentu
  Future<void> togglePlayback(int index) async {
    if (state is! SurahSuccess) return;
    final currentState = state as SurahSuccess;

    if (currentState.playingIndex == index) {
      // Toggle play/pause untuk ayat yang sama
      if (currentState.isPlaying) {
        await _audioPlayer.pause();
        _updateSuccess(
          currentState.ayahs,
          playingIndex: index,
          isPlaying: false,
        );
      } else {
        await _audioPlayer.resume();
        _updateSuccess(
          currentState.ayahs,
          playingIndex: index,
          isPlaying: true,
        );
      }
    } else {
      // Ganti ke ayat baru
      final ayah = currentState.ayahs[index];
      await _audioPlayer.play(ayah.audioLink);
      _updateSuccess(currentState.ayahs, playingIndex: index, isPlaying: true);
    }
    // tidak perlu notifyListeners() karena setState sudah handle
  }

  /// Callback saat audio selesai
  bool _isHandlingComplete = false;

  void onAudioComplete() {
    if (_isHandlingComplete) return;
    _isHandlingComplete = true;
    if (state is! SurahSuccess) return;
    final currentState = state as SurahSuccess;
    final currentIndex = currentState.playingIndex;

    if (currentIndex == null || currentIndex >= currentState.ayahs.length - 1) {
      // Stop playback kalau sudah ayat terakhir
      _updateSuccess(currentState.ayahs, playingIndex: null, isPlaying: false);
    } else {
      // Lanjut ke ayat berikutnya
      final nextIndex = currentIndex + 1;
      final nextAyah = currentState.ayahs[nextIndex];

      _audioPlayer.play(nextAyah.audioLink);
      _updateSuccess(
        currentState.ayahs,
        playingIndex: nextIndex,
        isPlaying: true,
      );
    }
    _isHandlingComplete = false;
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
      final newAyahs = await _ayahRepo.getAyahsBySurahId(first.surahNumber - 1);
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
