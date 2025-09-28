import 'package:mtqmnuns/dto/surah.dart';
import 'package:mtqmnuns/repositories/ayah.dart';
import 'package:mtqmnuns/services/audio_player.dart';
import 'package:mtqmnuns/state/surah.dart';
import 'package:mtqmnuns/viewmodel/stateful_generic_helper.dart';

class SurahViewModel extends StatefulViewModel<SurahDetailState> {
  final AyahRepository _ayahRepo;
  final AudioPlayerService _audioPlayer = AudioPlayerService();

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

  Future<void> togglePlayback(int index) async {
    if (state is! SurahSuccess) return;
    final currentState = state as SurahSuccess;

    if (currentState.playingIndex == index) {
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
    if (state is! SurahSuccess) return;
    final ayahs = (state as SurahSuccess).ayahs;
    final last = ayahs.lastOrNull;
    if (last == null) {
      setState(SurahError("Internal Error(500)"));
      return;
    }
    if (last.surahNumber == 114) return;
    try {
      if (last.number < last.totalAyah) {
        final newAyahs = await _ayahRepo.getAyahsInRange(
          startSurahId: last.surahNumber,
          startAyahNumber: last.number + 1,
          endSurahId: last.surahNumber,
          endAyahNumber: last.totalAyah,
        );
        _updateSuccess([...ayahs, ...newAyahs], jumpIndex: ayahs.length - 1);
      } else {
        final newAyahs = await _ayahRepo.getAyahsBySurahId(
          last.surahNumber + 1,
        );
        _updateSuccess([...ayahs, ...newAyahs], jumpIndex: ayahs.length - 1);
      }
    } catch (e) {
      _updateSuccess(ayahs, warning: "Load Failed");
    }
  }

  Future<void> prependBySurah() async {
    if (state is! SurahSuccess) return;
    final ayahs = (state as SurahSuccess).ayahs;
    final first = ayahs.firstOrNull;
    if (first == null) {
      setState(SurahError("Internal Error(500)"));
      return;
    }
    if (first.surahNumber == 1) return;

    try {
      if (first.number > 1) {
        final newAyahs = await _ayahRepo.getAyahsInRange(
          startSurahId: first.surahNumber,
          startAyahNumber: 1,
          endSurahId: first.surahNumber,
          endAyahNumber: first.number - 1,
        );
        _updateSuccess([...ayahs, ...newAyahs], jumpIndex: ayahs.length - 1);
      } else {
        final newAyahs = await _ayahRepo.getAyahsBySurahId(
          first.surahNumber - 1,
        );
        _updateSuccess([...newAyahs, ...ayahs], jumpIndex: newAyahs.length);
      }
    } catch (e) {
      _updateSuccess(ayahs, warning: "Load Failed");
    }
  }

  Future<void> appendByJuz() async {
    if (state is! SurahSuccess) return;
    final ayahs = (state as SurahSuccess).ayahs;
    final last = ayahs.lastOrNull;
    if (last == null) {
      setState(SurahError("Internal Error(500)"));
      return;
    }
    if (last.juzNumber == 30) return;

    try {
      final newAyahs = await _ayahRepo.getAyahsByJuz(last.juzNumber + 1);
      _updateSuccess([...ayahs, ...newAyahs], jumpIndex: ayahs.length - 1);
    } catch (e) {
      _updateSuccess(ayahs, warning: "Load Failed");
    }
  }

  Future<void> prependByJuz() async {
    if (state is! SurahSuccess) return;
    final ayahs = (state as SurahSuccess).ayahs;
    final first = ayahs.firstOrNull;
    if (first == null) {
      setState(SurahError("Internal Error(500)"));
      return;
    }
    if (first.juzNumber == 1) return;

    try {
      final newAyahs = await _ayahRepo.getAyahsByJuz(first.juzNumber - 1);
      _updateSuccess([...newAyahs, ...ayahs], jumpIndex: newAyahs.length);
    } catch (e) {
      _updateSuccess(ayahs, warning: "Load Failed");
    }
  }

  Future<void> appendSurahByCount(int count) async {
    if (state is! SurahSuccess) return;
    final ayahs = (state as SurahSuccess).ayahs;
    final first = ayahs.firstOrNull;
    if (first == null) {
      setState(SurahError("Internal Error(500)"));
      return;
    }
    if (first.surahNumber == 1) return;

    try {
      final newAyahs = await _ayahRepo.getPreviousAyahs(
        endSurahId: first.surahNumber,
        endAyahNumber: first.number,
        count: count,
      );
      _updateSuccess([...newAyahs, ...ayahs], jumpIndex: ayahs.length - 1);
    } catch (e) {
      _updateSuccess(ayahs, warning: "Load Failed");
    }
  }

  Future<void> prependSurahByCount(int count) async {
    if (state is! SurahSuccess) return;
    final ayahs = (state as SurahSuccess).ayahs;
    final last = ayahs.lastOrNull;
    if (last == null) {
      setState(SurahError("Internal Error(500)"));
      return;
    }
    if (last.surahNumber == 114) return;

    try {
      final newAyahs = await _ayahRepo.getNextAyahs(
        startSurahId: last.surahNumber,
        startAyahNumber: last.number,
        count: count,
      );
      _updateSuccess([...ayahs, ...newAyahs], jumpIndex: newAyahs.length);
    } catch (e) {
      _updateSuccess(ayahs, warning: "Load Failed");
    }
  }

  Future<void> loadByPage(int pageNumber) async {
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
      }
    }
    setState(SurahLoading());
    try {
      final data = await _ayahRepo.getAyahsByPage(pageNumber);
      _updateSuccess(data);
    } catch (e) {
      setState(SurahError(e.toString()));
    }
  }

  Future<void> loadPageByJuz(int juzNumber) async {
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
      }
    }
    setState(SurahLoading());
    try {
      final data = await _ayahRepo.getAyahsByFirstJuzPage(juzNumber);
      _updateSuccess(data);
    } catch (e) {
      setState(SurahError(e.toString()));
    }
  }

  Future<void> loadAyahsInPageOf(int surahId, int ayahNumber) async {
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
      }
    }
    setState(SurahLoading());
    try {
      final data = await _ayahRepo.getAyahsInPageOf(surahId, ayahNumber);
      _updateSuccess(data);
    } catch (e) {
      setState(SurahError(e.toString()));
    }
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

  Future<bool?> toggleFavorite(int surahId, int ayahNumber) async {
    if (state is! SurahSuccess) return null;

    try {
      final result = await _ayahRepo.toggleFavorite(surahId, ayahNumber);
      if (result != null) {
        final currentState = state as SurahSuccess;
        final updatedAyahs =
            currentState.ayahs.map((ayah) {
              if (ayah.surahNumber == surahId && ayah.number == ayahNumber) {
                return AyahWithSurahDto(
                  ayah.number,
                  ayah.audioLink,
                  ayah.juzNumber,
                  ayah.surahNumber,
                  ayah.surahName,
                  ayah.nameLatin,
                  ayah.nameIndo,
                  ayah.arabText,
                  ayah.translationText,
                  ayah.totalAyah,
                  ayah.page,
                  result,
                );
              }
              return ayah;
            }).toList();

        _updateSuccess(updatedAyahs);
      }
      return result;
    } catch (e) {
      _updateSuccess(
        (state as SurahSuccess).ayahs,
        warning: "Failed to update favorite",
      );
      return null;
    }
  }
}
