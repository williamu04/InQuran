import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:fuzzywuzzy/fuzzywuzzy.dart';
import 'package:inquran/common/navigation.dart';
import 'package:inquran/common/voice_actions.dart';
import 'package:inquran/config/global.dart';
import 'package:inquran/data/local/dao/surah_dao.dart';
import 'package:inquran/data/local/dao/doa_dao.dart';
import 'package:inquran/data/local/dao/juz_dao.dart';
import 'package:inquran/data/local/db/app_database.dart';
import 'package:inquran/dto/juz.dart';
import 'package:inquran/dto/surah.dart';
import 'package:inquran/services/id_number_parser.dart';

/// A recognized voice command. Pure data, so the matching pipeline is unit
/// testable without a widget tree (see test/stt_repository_test.dart).
sealed class VoiceIntent {}

class HelpIntent extends VoiceIntent {}

class OpenSurahIntent extends VoiceIntent {
  final SurahInfoDto surah;
  final int? ayahNumber;
  OpenSurahIntent(this.surah, {this.ayahNumber});
}

class OpenJuzIntent extends VoiceIntent {
  final JuzInfoDto juz;
  OpenJuzIntent(this.juz);
}

class OpenDoaCategoryIntent extends VoiceIntent {
  final DoaCategoryData category;
  OpenDoaCategoryIntent(this.category);
}

/// Navigation to a registered route handled by `lib/common/navigation.dart`.
enum VoiceDestination { home, surahList, doaList, search, favorites, qibla, prayer }

class NavigateIntent extends VoiceIntent {
  final VoiceDestination destination;
  NavigateIntent(this.destination);
}

class QuranModeIntent extends VoiceIntent {
  final QuranMode mode;
  QuranModeIntent(this.mode);
}

class VoiceModeOffIntent extends VoiceIntent {}

class PlaybackIntent extends VoiceIntent {
  final PlaybackCommand command;
  PlaybackIntent(this.command);
}

class PageIntent extends VoiceIntent {
  final int page;
  PageIntent(this.page);
}

class RelativeIntent extends VoiceIntent {
  final RelativeVoiceTarget target;
  RelativeIntent(this.target);
}

/// Ordered voice-command intent pipeline.
///
/// Matches in priority order (see ACCESSIBILITY.md §3.1). Earlier intents win,
/// which resolves collisions like "baca al quran" (opens the surah list, not
/// surah Quraysh) and "mode normal" (reading mode, never voice mode).
class SttRepository {
  final SurahDao _surahDao;
  final JuzDao _juzDao;
  final DoaDao _doaDao;

  SttRepository(
    this._surahDao,
    this._juzDao,
    this._doaDao,
  );

  static const int _maxJuz = 30;
  static const int _maxPage = 604;

  Future<void Function(BuildContext context)> processTranscription(
    String input,
  ) async {
    final intent = await resolveIntent(input);
    if (intent == null) throw StateError("Command Tidak Berhasil");

    return (context) => _execute(context, intent);
  }

  void _execute(BuildContext context, VoiceIntent intent) {
    switch (intent) {
      case HelpIntent():
        VoiceActions.helpAction()(context);
      case OpenSurahIntent(:final surah, :final ayahNumber):
        if (ayahNumber != null) {
          navigateToSurahAyah(context, surah, ayahNumber);
        } else {
          navigateToSurah(context, surah);
        }
      case OpenJuzIntent(:final juz):
        navigateToJuz(context, juz);
      case OpenDoaCategoryIntent(:final category):
        navigateToDoaCategory(context, category);
      case NavigateIntent(:final destination):
        _navigate(context, destination);
      case QuranModeIntent(:final mode):
        VoiceActions.quranModeAction(mode)(context);
      case VoiceModeOffIntent():
        VoiceActions.voiceModeOffAction()(context);
      case PlaybackIntent(:final command):
        VoiceActions.playbackAction(command)(context);
      case PageIntent(:final page):
        VoiceActions.pageAction(page)(context);
      case RelativeIntent(:final target):
        VoiceActions.relativeAction(target)(context);
    }
  }

  void _navigate(BuildContext context, VoiceDestination destination) {
    switch (destination) {
      case VoiceDestination.home:
        navigateToHome(context);
      case VoiceDestination.surahList:
        navigateToSurahList(context);
      case VoiceDestination.doaList:
        navigateToDoaList(context);
      case VoiceDestination.search:
        navigateToSearch(context);
      case VoiceDestination.favorites:
        navigateToFavorites(context);
      case VoiceDestination.qibla:
        navigateToQibla(context);
      case VoiceDestination.prayer:
        navigateToPrayer(context);
    }
  }

  /// Resolves an utterance into a [VoiceIntent]. Returns null when nothing
  /// matches (the caller decides how to recover).
  Future<VoiceIntent?> resolveIntent(String input) async {
    final normalized = _normalize(input);
    if (normalized.isEmpty) return null;
    final tokens = normalized.split(RegExp(r'\s+'));

    // 1. Help
    if (fuzzyMatchCommand(normalized, [
      'bantuan',
      'perintah apa saja',
      'apa saja perintah',
      'bisa apa',
      'help',
    ])) {
      return HelpIntent();
    }

    // 2. App navigation (before fuzzy surah matching to avoid collisions)
    if (fuzzyMatchCommand(normalized, [
      'beranda',
      'menu utama',
      'halaman utama',
      'kembali ke beranda',
      'kembali ke menu',
      'buka beranda',
      'buka menu utama',
    ])) {
      return NavigateIntent(VoiceDestination.home);
    }

    if (fuzzyMatchCommand(normalized, [
      'daftar surah',
      'buka daftar surah',
      'baca al quran',
      'buka al quran',
      'baca quran',
      'buka quran',
      'al quran',
      'kumpulan surah',
    ])) {
      return NavigateIntent(VoiceDestination.surahList);
    }

    if (fuzzyMatchCommand(normalized, [
      'koleksi doa',
      'daftar doa',
      'buka daftar doa',
      'buka koleksi doa',
      'kumpulan doa',
    ])) {
      return NavigateIntent(VoiceDestination.doaList);
    }

    if (fuzzyMatchCommand(normalized, [
      'cari',
      'pencarian',
      'jelajahi',
      'jelajah',
      'cari ayat',
      'cari kata',
      'cari kalimat',
    ])) {
      return NavigateIntent(VoiceDestination.search);
    }

    if (fuzzyMatchCommand(normalized, [
      'favorit',
      'ayat favorit',
      'daftar favorit',
      'buka ayat favorit',
      'buka favorit',
    ])) {
      return NavigateIntent(VoiceDestination.favorites);
    }

    // 3. Voice mode off (before reading-mode: requires "suara"/"voice")
    if (fuzzyMatchCommand(normalized, [
      'matikan mode suara',
      'mode suara',
      'matikan suara',
      'keluar mode suara',
      'keluar mode voice',
      'suara nonaktif',
      'voice off',
      'matikan voice',
    ])) {
      return VoiceModeOffIntent();
    }

    // 4. Al-Qur'an reading mode
    if (normalized.contains('mushaf')) {
      return QuranModeIntent(QuranMode.mushaf);
    }
    if (normalized.contains('hafalan')) {
      return QuranModeIntent(QuranMode.memorize);
    }
    if (normalized.contains('normal') &&
        (normalized.contains('mode') || normalized.contains('baca'))) {
      return QuranModeIntent(QuranMode.normal);
    }

    // 5. Audio playback
    if (fuzzyMatchCommand(normalized, [
      'putar',
      'putarkan',
      'jeda',
      'pause',
      'lanjut',
      'lanjutkan',
      'hentikan audio',
      'hentikan suara',
      'stop audio',
      'matikan audio',
    ])) {
      return PlaybackIntent(_resolvePlaybackCommand(normalized));
    }

    // 6. Page navigation (absolute or relative)
    if (tokens.contains('halaman')) {
      if (_containsAny(normalized, ['berikutnya', 'selanjutnya'])) {
        return RelativeIntent(RelativeVoiceTarget.nextPage);
      }
      if (normalized.contains('sebelumnya')) {
        return RelativeIntent(RelativeVoiceTarget.previousPage);
      }
      final page = _extractNumberAfter(tokens, ['halaman']);
      if (page != null && page >= 1 && page <= _maxPage) {
        return PageIntent(page);
      }
    }

    // 7. Juz navigation (absolute or relative)
    if (tokens.contains('juz')) {
      if (_containsAny(normalized, ['berikutnya', 'selanjutnya'])) {
        return RelativeIntent(RelativeVoiceTarget.nextJuz);
      }
      if (normalized.contains('sebelumnya')) {
        return RelativeIntent(RelativeVoiceTarget.previousJuz);
      }
      final juzNumber = _extractNumberAfter(tokens, ['juz']);
      if (juzNumber != null && juzNumber >= 1 && juzNumber <= _maxJuz) {
        final info = await _juzDao.getJuzInfo(juzNumber);
        if (info != null) {
          return OpenJuzIntent(JuzInfoDto.fromEntity(info));
        }
      }
    }

    // 8. Surah at a specific ayah: "<nama surah> ayat <nomor>"
    final ayatIndex = tokens.indexOf('ayat');
    if (ayatIndex != -1) {
      final number = IdNumberParser.parseFromTokens(tokens.sublist(ayatIndex + 1));
      if (number != null && number >= 1) {
        final surahPhrase = tokens.sublist(0, ayatIndex).join(' ').trim();
        final surah = await fuzzyFindSurahFromText(
          surahPhrase.isNotEmpty ? surahPhrase : normalized,
        );
        if (surah != null) {
          return OpenSurahIntent(surah, ayahNumber: number);
        }
      }
    }

    // 9. Relative surah navigation
    if (tokens.contains('surah')) {
      if (_containsAny(normalized, ['berikutnya', 'selanjutnya'])) {
        return RelativeIntent(RelativeVoiceTarget.nextSurah);
      }
      if (normalized.contains('sebelumnya')) {
        return RelativeIntent(RelativeVoiceTarget.previousSurah);
      }
    }

    // 10. Qibla (before plain-surah fuzzy: "arah kiblat" must not match a
    // surah name that happens to contain "arah", e.g. Al-Baqarah)
    if (fuzzyMatchCommand(normalized, [
      'qibla',
      'kiblat',
      'kompas',
      'kompas qibla',
      'arah kiblat',
    ])) {
      return NavigateIntent(VoiceDestination.qibla);
    }

    // 11. Prayer times (before plain-surah fuzzy: doa categories named
    // "Doa ... Sholat" must not steal prayer-time intents)
    if (fuzzyMatchCommand(normalized, [
      'waktu sholat',
      'jadwal sholat',
      'waktu shalat',
      'jadwal shalat',
      'prayer time',
      'prayer times',
      'sholat',
      'jadwal',
      'waktu',
    ])) {
      return NavigateIntent(VoiceDestination.prayer);
    }

    // 12. Plain surah fuzzy match
    final surah = await fuzzyFindSurahFromText(normalized);
    if (surah != null) {
      return OpenSurahIntent(surah);
    }

    // 13. Doa category fuzzy match
    final doaCategory = await fuzzyFindDoaCategoryFromText(normalized);
    if (doaCategory != null) {
      return OpenDoaCategoryIntent(doaCategory);
    }

    return null;
  }

  PlaybackCommand _resolvePlaybackCommand(String normalized) {
    if (_containsAny(normalized, ['jeda', 'pause'])) return PlaybackCommand.pause;
    if (normalized.contains('lanjut')) return PlaybackCommand.resume;
    if (_containsAny(normalized, ['hentikan', 'stop', 'matikan'])) {
      return PlaybackCommand.stop;
    }
    return PlaybackCommand.playPause;
  }

  /// Extracts the number that follows an anchor token (e.g. "juz tiga puluh").
  int? _extractNumberAfter(List<String> tokens, List<String> anchors) {
    for (final anchor in anchors) {
      final index = tokens.indexOf(anchor);
      if (index == -1 || index == tokens.length - 1) continue;

      final numberTokens = <String>[];
      for (final token in tokens.sublist(index + 1)) {
        if (IdNumberParser.isNumberWord(token)) {
          numberTokens.add(token);
        } else {
          break;
        }
      }
      if (numberTokens.isEmpty) continue;

      final number = IdNumberParser.parseFromTokens(numberTokens);
      if (number != null) return number;
    }
    return null;
  }

  bool _containsAny(String input, List<String> needles) {
    for (final needle in needles) {
      if (input.contains(needle)) return true;
    }
    return false;
  }

  String _normalize(String input) {
    final lowered = input.toLowerCase();
    final cleaned = lowered.replaceAll(RegExp(r"[^\w\s'’]"), ' ');
    return cleaned.replaceAll(RegExp(r'\s+'), ' ').trim();
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

  /// Return true if any of the [keywords] fuzzy-match the input.
  ///
  /// Multi-word keywords only match at the full-phrase level (threshold 85) so
  /// that similar-shaped command phrases do not cross-match ("daftar surah"
  /// must never trigger the help or doa-list intents). Single-word keywords
  /// also match at token level, so leading/trailing words like "buka ..." are
  /// tolerated.
  bool fuzzyMatchCommand(
    String input,
    List<String> keywords, {
    int threshold = 85,
  }) {
    final normalized = input.toLowerCase();

    int best = 0;
    for (var kw in keywords) {
      final k = kw.toLowerCase();
      // full phrase match
      best = max(best, ratio(normalized, k));

      // token-level match for single-word keywords only
      if (!k.contains(RegExp(r'\s'))) {
        for (var token in normalized.split(RegExp(r'\s+'))) {
          if (token.length <= 2) continue;
          best = max(best, ratio(token, k));
        }
      }
    }

    return best >= threshold;
  }

  /// Find the doa category that best matches the input. Returns null if none found.
  Future<DoaCategoryData?> fuzzyFindDoaCategoryFromText(String input) async {
    final categories = await _doaDao.getDoaCategories();
    final normalized = input.toLowerCase();

    DoaCategoryData? best;
    int bestScore = 0;

    for (var c in categories) {
      final name = c.nama.toLowerCase();
      int score = ratio(normalized, name);

      // also try token-level matching (e.g., user says only the category word)
      for (var token in normalized.split(RegExp(r'\s+'))) {
        if (token.length <= 2) continue;
        score = max(score, ratio(token, name));
      }

      if (score > bestScore) {
        bestScore = score;
        best = c;
      }
    }

    // threshold tuned for category names
    if (best != null && bestScore >= 65) return best;
    return null;
  }
}
