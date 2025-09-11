import 'package:mtqmnuns/config/Global.dart';
import 'package:mtqmnuns/dto/surah.dart';

sealed class SurahDetailState {}

class SurahLoading extends SurahDetailState {}
class SurahError extends SurahDetailState {
  final String message;
  SurahError(this.message);
}
class SurahSuccess extends SurahDetailState {
  final SurahWithAyahDto surahWithAyahData;
  final QuranMode mode;
  SurahSuccess(this.surahWithAyahData, this.mode);
}
