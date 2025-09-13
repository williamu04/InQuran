import 'package:mtqmnuns/data/local/db/app_database.dart';

class SurahWithAyahs {
  final SurahData? surah;
  final List<AyahData> ayahs;

  SurahWithAyahs(this.surah, this.ayahs);
}

class AyahWithSurah {
  final SurahData surah; 
  final AyahData ayah;   

  const AyahWithSurah({
    required this.surah,
    required this.ayah,
  });
}