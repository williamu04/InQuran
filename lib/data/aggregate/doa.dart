import 'package:mtqmnuns/data/local/db/app_database.dart';

class CompleteDuaData {
  int id;
  DoaCategoryData doaCategory;
  AyahData ayah;
  SurahData? surah;

  CompleteDuaData(this.id, this.doaCategory, this.ayah, this.surah);
}
