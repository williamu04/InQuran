import 'package:mtqmnuns/data/local/db/app_database.dart';

class SurahInfoDto {
  final int number;
  final String name;
  final String nameLatin;
  final int totalAyah;
  final String place;

  SurahInfoDto(this.name, this.nameLatin, this.totalAyah, this.place, this.number);

  factory SurahInfoDto.fromEntity(SurahData entity) {
    return SurahInfoDto(
      entity.name,
      entity.nameLatin,
      entity.totalAyah,
      entity.place,
      entity.id, 
    );
  }
}

class AyahWithTranslation {
  final int number;
  final String arabText;
  final String translationText;

  AyahWithTranslation(this.number, this.arabText, this.translationText);
}

class SurahWithAyahDto {
  final int number;
  final String arabname; 
  final String nameLatin;
  final String nameIndo;
  final List<AyahWithTranslation> ayahs;

  SurahWithAyahDto(this.number,this.arabname, this.nameLatin, this.nameIndo, this.ayahs,);
}