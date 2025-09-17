import 'package:mtqmnuns/data/aggregate/surah.dart';
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
  factory AyahWithTranslation.fromEntity(AyahData entity) {
    return AyahWithTranslation(entity.ayahNumber, entity.ayahText, entity.indoText);

  }
}

class SurahWithAyahDto {
  final int number;
  final String arabname; 
  final String nameLatin;
  final String nameIndo;
  final List<AyahWithTranslation> ayahs;

  SurahWithAyahDto(this.number,this.arabname, this.nameLatin, this.nameIndo, this.ayahs,);
}

class AyahWithSurahDto {
  final int number;
  final int juzNumber;
  final int surahNumber;
  final String surahName;
  final String nameLatin;
  final String nameIndo;
  final String arabText;
  final String translationText;
  final int totalAyah;

  const AyahWithSurahDto(
    this.number,
    this.juzNumber,
    this.surahNumber,
    this.surahName,
    this.nameLatin,
    this.nameIndo,
    this.arabText,
    this.translationText,
    this.totalAyah,
  );

  factory AyahWithSurahDto.fromEntity(AyahWithSurah entity) {
    return AyahWithSurahDto(
      entity.ayah.ayahNumber,
      entity.ayah.juz,
      entity.surah.id,
      entity.surah.name,
      entity.surah.nameLatin,
      entity.surah.nameIndo,
      entity.ayah.ayahText,
      entity.ayah.indoText,
      entity.surah.totalAyah
    );
  }
}

class SurahParameter {
  final int startSurahId;
  final int startSurahAyah;
  final int endSurahId;
  final int endSurahAyah;
  SurahParameter(this.startSurahId, this.startSurahAyah, this.endSurahId, this.endSurahAyah);
}
