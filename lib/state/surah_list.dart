import 'package:inquran/dto/juz.dart';
import 'package:inquran/dto/surah.dart';

enum SurahContentType { surah, juz }

sealed class SurahListState {}

class SurahListLoading extends SurahListState {}

class SurahListSuccessTypeSurah extends SurahListState {
  final List<SurahInfoDto> surahs;
  SurahListSuccessTypeSurah({
    required this.surahs,
  });
}

class SurahListSuccessTypeJuz extends SurahListState {
  final List<JuzInfoDto> juz;
  SurahListSuccessTypeJuz({
    required this.juz,
  });
}

class SurahListSuccessEmpty extends SurahListState {}

class SurahListError extends SurahListState {
  final String message;
  SurahListError(this.message);
}
