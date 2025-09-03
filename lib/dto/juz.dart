
import 'package:mtqmnuns/data/aggregate/juz.dart';

class JuzInfoDto {
  final int juzNumber;
  final int startAyahNumber;
  final String startSurahName;
  final int startSurahTotalAyah;
  final int endAyahNumber;
  final String endSurahName;

  const JuzInfoDto({
    required this.juzNumber,
    required this.startAyahNumber,
    required this.startSurahName,
    required this.startSurahTotalAyah,
    required this.endAyahNumber,
    required this.endSurahName,
  });

  factory JuzInfoDto.fromEntity(JuzInfo entity) {
    return JuzInfoDto(
      juzNumber: entity.juzNumber,
      startAyahNumber: entity.startAyah.ayahNumber,
      startSurahName: entity.startSurah.nameLatin,
      startSurahTotalAyah: entity.startSurah.totalAyah,
      endAyahNumber: entity.endAyah.ayahNumber,
      endSurahName: entity.endSurah.nameLatin,
    );
  }
}