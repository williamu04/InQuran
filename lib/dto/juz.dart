
import 'package:inquran/data/aggregate/juz.dart';

class JuzInfoDto {
  final int juzNumber;
  final int startSurahNumber;
  final int startAyahNumber;
  final String startSurahName;
  final int startSurahTotalAyah;
  final int endSurahNumber;
  final int endAyahNumber;
  final String endSurahName;

  const JuzInfoDto({
    required this.juzNumber,
    required this.startSurahNumber,
    required this.startAyahNumber,
    required this.startSurahName,
    required this.startSurahTotalAyah,
    required this.endAyahNumber,
    required this.endSurahNumber,
    required this.endSurahName,
  });

  factory JuzInfoDto.fromEntity(JuzInfo entity) {
    return JuzInfoDto(
      juzNumber: entity.juzNumber,
      startAyahNumber: entity.startAyah.ayahNumber,
      startSurahNumber: entity.startSurah.id,
      startSurahName: entity.startSurah.nameLatin,
      startSurahTotalAyah: entity.startSurah.totalAyah,
      endAyahNumber: entity.endAyah.ayahNumber,
      endSurahNumber: entity.endSurah.id,
      endSurahName: entity.endSurah.nameLatin,
    );
  }
}