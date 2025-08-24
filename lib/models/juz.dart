import 'package:mtqmnuns/data/local/db/app_database.dart';

class JuzBoundary {
  final AyahData start;
  final AyahData end;

  const JuzBoundary({
    required this.start,
    required this.end,
  });

}

class JuzInfo {
  final int juzNumber;
  final AyahData startAyah;
  final SurahData startSurah;
  final AyahData endAyah;
  final SurahData endSurah;

  const JuzInfo({
    required this.juzNumber,
    required this.startAyah,
    required this.startSurah,
    required this.endAyah,
    required this.endSurah,
  });
}