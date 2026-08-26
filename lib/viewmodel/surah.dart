import 'package:flutter/material.dart';
import 'package:inquran/dto/surah.dart';
import 'package:inquran/repositories/ayah.dart';
import 'package:inquran/services/audio_player.dart';
import 'package:inquran/state/surah.dart';
import 'package:inquran/state/stateful_viewmodel.dart';

class SurahViewModel extends StatefulViewModel<SurahDetailState> {
  final AyahRepository _ayahRepo;
  final AudioPlayerService _audioPlayer = AudioPlayerService();

  List<AyahWithSurahDto>? _allAyahsCache;
  bool _isInitialized = false;

  SurahViewModel(this._ayahRepo) : super(SurahLoading()) {
    _audioPlayer.addPlayerCompleteListener(() {
      onAudioComplete();
    });

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

  Future<void> togglePlayback(int index) async {
    if (state is! SurahSuccess) return;
    final currentState = state as SurahSuccess;

    if (currentState.playingIndex == index) {
      if (currentState.isPlaying) {
        _updateSuccess(
          currentState.ayahs,
          playingIndex: index,
          isPlaying: false,
        );
        await _audioPlayer.pause();
      } else {
        _updateSuccess(
          currentState.ayahs,
          playingIndex: index,
          isPlaying: true,
        );
        await _audioPlayer.resume();
      }
    } else {
      _updateSuccess(currentState.ayahs, playingIndex: index, isPlaying: true);
      final ayah = currentState.ayahs[index];
      debugPrint('Starting playback of ayah ${ayah.number} at index $index');
      await _audioPlayer.play(ayah.audioLink);
    }
  }

  bool _isHandlingComplete = false;

  void onAudioComplete() {
    if (_isHandlingComplete) return;
    _isHandlingComplete = true;

    if (state is! SurahSuccess) return;
    final currentState = state as SurahSuccess;
    final currentIndex = currentState.playingIndex;

    debugPrint('Audio completed for index: $currentIndex');

    if (currentIndex == null || currentIndex >= currentState.ayahs.length - 1) {
      debugPrint('Reached end of ayahs, stopping playback');
      _updateSuccess(currentState.ayahs, playingIndex: null, isPlaying: false);
    } else {
      final nextIndex = currentIndex + 1;
      final nextAyah = currentState.ayahs[nextIndex];
      debugPrint('Moving to next ayah ${nextAyah.number} at index $nextIndex');

      _updateSuccess(
        currentState.ayahs,
        playingIndex: nextIndex,
        isPlaying: true,
      );
      _audioPlayer.play(nextAyah.audioLink);
    }

    _isHandlingComplete = false;
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

  Future<void> initializeCache() async {
    if (_isInitialized) return;

    setState(SurahLoading());
    try {
      _allAyahsCache = await _ayahRepo.getAllAyahWithSurah();
      _isInitialized = true;
    } catch (e) {
      setState(SurahError('Gagal memuat data: ${e.toString()}'));
      return;
    }
  }

  void _ensureCacheLoaded() {
    if (!_isInitialized || _allAyahsCache == null) {
      setState(
        SurahError('Cache not initialized. Call initializeCache() first.'),
      );
    }
  }

  bool isCacheLoaded() {
    return _allAyahsCache != null && _allAyahsCache!.isNotEmpty;
  }

  void loadSurah(
    int startSurahId,
    int startSurahAyah,
    int endSurahId,
    int endSurahAyah,
  ) {
    _ensureCacheLoaded();

    try {
      final filteredAyahs =
          _allAyahsCache!.where((ayah) {
            if (startSurahId == endSurahId) {
              return ayah.surahNumber == startSurahId &&
                  ayah.number >= startSurahAyah &&
                  ayah.number <= endSurahAyah;
            } else {
              return (ayah.surahNumber == startSurahId &&
                      ayah.number >= startSurahAyah) ||
                  (ayah.surahNumber > startSurahId &&
                      ayah.surahNumber < endSurahId) ||
                  (ayah.surahNumber == endSurahId &&
                      ayah.number <= endSurahAyah);
            }
          }).toList();

      if (filteredAyahs.isEmpty) {
        setState(SurahError('Tidak ada ayat dalam rentang yang dipilih'));
        return;
      }

      _updateSuccess(filteredAyahs, jumpIndex: 0);
    } catch (e) {
      setState(SurahError(e.toString()));
    }
  }

  void appendBySurah() {
    if (state is! SurahSuccess) return;
    _ensureCacheLoaded();

    final ayahs = (state as SurahSuccess).ayahs;
    final last = ayahs.lastOrNull;
    if (last == null || last.surahNumber == 114) return;

    try {
      List<AyahWithSurahDto> newAyahs;

      if (last.number < last.totalAyah) {
        newAyahs =
            _allAyahsCache!
                .where(
                  (ayah) =>
                      ayah.surahNumber == last.surahNumber &&
                      ayah.number > last.number,
                )
                .toList();
      } else {
        newAyahs =
            _allAyahsCache!
                .where((ayah) => ayah.surahNumber == last.surahNumber + 1)
                .toList();
      }

      if (newAyahs.isNotEmpty) {
        _updateSuccess([...ayahs, ...newAyahs], jumpIndex: ayahs.length - 1);
      }
    } catch (e) {
      _updateSuccess(ayahs, warning: "Load Failed");
    }
  }

  void prependBySurah() {
    if (state is! SurahSuccess) return;
    _ensureCacheLoaded();

    final ayahs = (state as SurahSuccess).ayahs;
    final first = ayahs.firstOrNull;
    if (first == null || first.surahNumber == 1) return;

    try {
      List<AyahWithSurahDto> newAyahs;

      if (first.number > 1) {
        newAyahs =
            _allAyahsCache!
                .where(
                  (ayah) =>
                      ayah.surahNumber == first.surahNumber &&
                      ayah.number < first.number,
                )
                .toList();
      } else {
        newAyahs =
            _allAyahsCache!
                .where((ayah) => ayah.surahNumber == first.surahNumber - 1)
                .toList();
      }

      if (newAyahs.isNotEmpty) {
        _updateSuccess([...newAyahs, ...ayahs], jumpIndex: newAyahs.length);
      }
    } catch (e) {
      _updateSuccess(ayahs, warning: "Load Failed");
    }
  }

  void appendByJuz() {
    if (state is! SurahSuccess) return;
    _ensureCacheLoaded();

    final ayahs = (state as SurahSuccess).ayahs;
    final last = ayahs.lastOrNull;
    if (last == null || last.juzNumber == 30) return;

    try {
      final newAyahs =
          _allAyahsCache!
              .where((ayah) => ayah.juzNumber == last.juzNumber + 1)
              .toList();

      if (newAyahs.isNotEmpty) {
        _updateSuccess([...ayahs, ...newAyahs], jumpIndex: ayahs.length - 1);
      }
    } catch (e) {
      _updateSuccess(ayahs, warning: "Load Failed");
    }
  }

  void prependByJuz() {
    if (state is! SurahSuccess) return;
    _ensureCacheLoaded();

    final ayahs = (state as SurahSuccess).ayahs;
    final first = ayahs.firstOrNull;
    if (first == null || first.juzNumber == 1) return;

    try {
      final newAyahs =
          _allAyahsCache!
              .where((ayah) => ayah.juzNumber == first.juzNumber - 1)
              .toList();

      if (newAyahs.isNotEmpty) {
        _updateSuccess([...newAyahs, ...ayahs], jumpIndex: newAyahs.length);
      }
    } catch (e) {
      _updateSuccess(ayahs, warning: "Load Failed");
    }
  }

  void appendSurahByCount(int count) {
    if (state is! SurahSuccess) return;
    _ensureCacheLoaded();

    final ayahs = (state as SurahSuccess).ayahs;
    final first = ayahs.firstOrNull;
    if (first == null || first.surahNumber == 1) return;

    try {
      final allPrevious =
          _allAyahsCache!
              .where(
                (ayah) =>
                    ayah.surahNumber < first.surahNumber ||
                    (ayah.surahNumber == first.surahNumber &&
                        ayah.number < first.number),
              )
              .toList();

      final newAyahs =
          allPrevious.length > count
              ? allPrevious.sublist(allPrevious.length - count)
              : allPrevious;

      if (newAyahs.isNotEmpty) {
        _updateSuccess([...newAyahs, ...ayahs], jumpIndex: newAyahs.length);
      }
    } catch (e) {
      _updateSuccess(ayahs, warning: "Load Failed");
    }
  }

  void prependSurahByCount(int count) {
    if (state is! SurahSuccess) return;
    _ensureCacheLoaded();

    final ayahs = (state as SurahSuccess).ayahs;
    final last = ayahs.lastOrNull;
    if (last == null || last.surahNumber == 114) return;

    try {
      final allNext =
          _allAyahsCache!
              .where(
                (ayah) =>
                    ayah.surahNumber > last.surahNumber ||
                    (ayah.surahNumber == last.surahNumber &&
                        ayah.number > last.number),
              )
              .toList();

      final newAyahs =
          allNext.length > count ? allNext.sublist(0, count) : allNext;

      if (newAyahs.isNotEmpty) {
        _updateSuccess([...ayahs, ...newAyahs], jumpIndex: newAyahs.length);
      }
    } catch (e) {
      _updateSuccess(ayahs, warning: "Load Failed");
    }
  }

  void loadByPage(int pageNumber) {
    if (pageNumber < 1 || pageNumber > 604) {
      if (state is SurahSuccess) {
        setState(
          SurahSuccess(
            (state as SurahSuccess).ayahs,
            warning: "sudah mencapai halaman terakhir",
          ),
        );
        return;
      } else {
        setState(SurahError("invalid halaman"));
        return;
      }
    }

    _ensureCacheLoaded();

    try {
      final pageAyahs =
          _allAyahsCache!.where((ayah) => ayah.page == pageNumber).toList();

      if (pageAyahs.isEmpty) {
        setState(SurahError("Tidak ada ayat untuk halaman $pageNumber"));
        return;
      }

      _updateSuccess(pageAyahs);
    } catch (e) {
      setState(SurahError(e.toString()));
    }
  }

  void loadPageByJuz(int juzNumber) {
    if (juzNumber < 1 || juzNumber > 30) {
      if (state is SurahSuccess) {
        setState(
          SurahSuccess(
            (state as SurahSuccess).ayahs,
            warning: "sudah mencapai juz terakhir",
          ),
        );
        return;
      } else {
        setState(SurahError("invalid juz"));
        return;
      }
    }

    _ensureCacheLoaded();

    try {
      final juzAyahs =
          _allAyahsCache!.where((ayah) => ayah.juzNumber == juzNumber).toList();

      if (juzAyahs.isEmpty) {
        setState(SurahError("Tidak ada ayat untuk juz $juzNumber"));
        return;
      }

      final firstPage = juzAyahs
          .map((a) => a.page)
          .reduce((a, b) => a < b ? a : b);
      loadByPage(firstPage);
    } catch (e) {
      setState(SurahError(e.toString()));
    }
  }

  void loadAyahsInPageOf(int surahId, int ayahNumber) {
    if (surahId < 1 || surahId > 114) {
      if (state is SurahSuccess) {
        setState(
          SurahSuccess(
            (state as SurahSuccess).ayahs,
            warning: "sudah mencapai surah terakhir",
          ),
        );
        return;
      } else {
        setState(SurahError("invalid surah"));
        return;
      }
    }

    _ensureCacheLoaded();

    try {
      final targetAyah =
          _allAyahsCache!
              .where(
                (ayah) =>
                    ayah.surahNumber == surahId && ayah.number == ayahNumber,
              )
              .firstOrNull;

      if (targetAyah == null) {
        setState(SurahError("Ayah not found"));
        return;
      }

      loadByPage(targetAyah.page);
    } catch (e) {
      setState(SurahError(e.toString()));
    }
  }

  Future<void> loadAllAyahs() async {
    await initializeCache();
    if (_allAyahsCache != null) {
      _updateSuccess(_allAyahsCache!);
    }
  }

  Future<bool?> toggleFavorite(int surahId, int ayahNumber) async {
    return true;
  }
}
