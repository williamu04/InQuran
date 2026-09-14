import 'package:flutter/material.dart';
import 'package:inquran/common/announcement.dart';
import 'package:inquran/config/global.dart';
import 'package:inquran/state/surah.dart';
import 'package:inquran/state/ui_controllers.dart';
import 'package:inquran/viewmodel/surah.dart';
import 'package:provider/provider.dart';

/// Closures used as voice-command actions. They receive the nearest
/// [BuildContext] at execution time (after navigation is possible), so they
/// resolve dependencies through the provider tree instead of holding DAOs.
class VoiceActions {
  static void _announce(String message) {
    announceToScreenReader(message);
  }

  /// Switches the Al-Qur'an reading mode (normal / memorize / mushaf).
  static void Function(BuildContext context) quranModeAction(QuranMode mode) {
    return (context) {
      context.read<GlobalConfig>().setQuranMode(mode);
      _announce('Mode diubah ke ${_quranModeName(mode)}.');
    };
  }

  /// Exits voice command mode.
  static void Function(BuildContext context) voiceModeOffAction() {
    return (context) {
      context.read<GlobalConfig>().setVoiceMode(false);
      _announce('Mode suara dinonaktifkan. Kembali ke mode normal.');
    };
  }

  /// Opens the voice command help popup.
  static void Function(BuildContext context) helpAction() {
    return (context) {
      context.read<VoiceCommandHelpController>().open();
    };
  }

  /// Audio playback control on the current surah screen.
  static void Function(BuildContext context) playbackAction(
    PlaybackCommand command,
  ) {
    return (context) {
      final vm = context.read<SurahViewModel>();
      final state = vm.state;
      if (state is! SurahSuccess) {
        _announce('Buka surah terlebih dahulu untuk mengatur audio.');
        return;
      }

      switch (command) {
        case PlaybackCommand.playPause:
          vm.togglePlayback(state.playingIndex ?? 0);
        case PlaybackCommand.pause:
          if (state.isPlaying && state.playingIndex != null) {
            vm.togglePlayback(state.playingIndex!);
          } else {
            _announce('Tidak ada audio yang sedang diputar.');
          }
        case PlaybackCommand.resume:
          if (!state.isPlaying) {
            vm.togglePlayback(state.playingIndex ?? 0);
          } else {
            _announce('Audio sudah berjalan.');
          }
        case PlaybackCommand.stop:
          if (state.isPlaying && state.playingIndex != null) {
            vm.togglePlayback(state.playingIndex!);
          } else {
            _announce('Tidak ada audio yang sedang diputar.');
          }
      }
    };
  }

  /// Jumps to an absolute mushaf page.
  static void Function(BuildContext context) pageAction(int page) {
    return (context) {
      final vm = context.read<SurahViewModel>();
      final state = vm.state;
      if (state is! SurahSuccess) {
        _announce('Buka surah terlebih dahulu.');
        return;
      }
      if (page < 1 || page > 604) {
        _announce('Nomor halaman harus antara satu sampai enam ratus empat.');
        return;
      }
      vm.loadByPage(page);
      _announce('Membuka halaman $page.');
    };
  }

  /// Relative jumps on the current reading screen (next/prev page, juz, surah).
  static void Function(BuildContext context) relativeAction(
    RelativeVoiceTarget target,
  ) {
    return (context) {
      final vm = context.read<SurahViewModel>();
      final state = vm.state;
      if (state is! SurahSuccess || state.ayahs.isEmpty) {
        _announce('Buka surah terlebih dahulu.');
        return;
      }

      switch (target) {
        case RelativeVoiceTarget.nextPage:
          vm.loadByPage(state.ayahs.last.page + 1);
        case RelativeVoiceTarget.previousPage:
          vm.loadByPage(state.ayahs.last.page - 1);
        case RelativeVoiceTarget.nextJuz:
          vm.loadPageByJuz(state.ayahs.last.juzNumber + 1);
        case RelativeVoiceTarget.previousJuz:
          vm.loadPageByJuz(state.ayahs.last.juzNumber - 1);
        case RelativeVoiceTarget.nextSurah:
          vm.loadAyahsInPageOf(state.ayahs.last.surahNumber + 1, 1);
        case RelativeVoiceTarget.previousSurah:
          vm.loadAyahsInPageOf(state.ayahs.last.surahNumber - 1, 1);
      }
    };
  }

  static String _quranModeName(QuranMode mode) {
    return switch (mode) {
      QuranMode.normal => 'baca normal',
      QuranMode.memorize => 'hafalan',
      QuranMode.mushaf => 'mushaf',
    };
  }
}

enum PlaybackCommand { playPause, pause, resume, stop }

/// Relative navigation targets on the current reading screen.
enum RelativeVoiceTarget { nextPage, previousPage, nextJuz, previousJuz, nextSurah, previousSurah }
