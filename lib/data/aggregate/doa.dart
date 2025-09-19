import 'package:mtqmnuns/data/local/db/app_database.dart';

class CompleteDuaData {
  int id;
  DoaCategoryData doaCategory;
  SurahData surah;
  List<AyahData> ayatList; // 🔹 kumpulan ayat

  CompleteDuaData({
    required this.id,
    required this.doaCategory,
    required this.surah,
    required this.ayatList,
  });
}
