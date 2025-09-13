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

  SurahSuccess(this.ayahs, {this.warning});
}

