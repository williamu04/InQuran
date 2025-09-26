import 'package:mtqmnuns/dto/surah.dart';

sealed class SurahDetailState {}

class SurahLoading extends SurahDetailState {}

class SurahError extends SurahDetailState {
  final String message;
  SurahError(this.message);
}

class SurahSuccess extends SurahDetailState {
  final List<AyahWithSurahDto> ayahs;
  final String? warning;
  final int? jumpIndex;
  final int? playingIndex;
  final bool isPlaying;

  SurahSuccess(
    this.ayahs, {
    this.jumpIndex,
    this.warning,
    this.playingIndex,
    this.isPlaying = false,
  });

  SurahSuccess copyWith({
    List<AyahWithSurahDto>? ayahs,
    String? warning,
    int? jumpIndex,
    int? playingIndex,
    bool? isPlaying,
  }) {
    return SurahSuccess(
      ayahs ?? this.ayahs,
      warning: warning ?? this.warning,
      jumpIndex: jumpIndex ?? this.jumpIndex,
      playingIndex: playingIndex ?? this.playingIndex,
      isPlaying: isPlaying ?? this.isPlaying,
    );
  }
}

enum LoadType { surah, juz }
