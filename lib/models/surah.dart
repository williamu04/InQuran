import 'package:mtqmnuns/data/local/db/app_database.dart';

class SurahWithAyahs {
  final SurahData surah;
  final List<AyahData> ayahs;

  SurahWithAyahs(this.surah, this.ayahs);
}

class SurahWithVerseCount {
  final SurahData surah;
  final int verseCount;

  SurahWithVerseCount(this.surah, this.verseCount);
}
