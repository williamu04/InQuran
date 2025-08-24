import 'package:mtqmnuns/data/local/db/app_database.dart';

class SurahWithAyahs {
  final SurahData surah;
  final List<AyahData> ayahs;

  SurahWithAyahs(this.surah, this.ayahs);
}

class SurahWithVerse {
  final SurahData surah;
  final int verse;

  SurahWithVerse(this.surah, this.verse);
}
