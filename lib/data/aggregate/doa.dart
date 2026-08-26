import 'package:inquran/data/local/db/app_database.dart';

class CompleteDoaData {
  int id;
  DoaCategoryData doaCategory;
  AyahData ayah;
  SurahData? surah;

  CompleteDoaData(this.id, this.doaCategory, this.ayah, this.surah);
}
