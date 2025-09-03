import 'package:mtqmnuns/data/local/dao/juz_dao.dart';
import 'package:mtqmnuns/dto/juz.dart';

class JuzRepository {
  final JuzDao _juzDao; 

  JuzRepository(this._juzDao);

Future<List<JuzInfoDto>> getAllJuz() async {
  final List<JuzInfoDto> result = [];

  for (int i = 1; i <= 30; i++) {
    final juzInfo = await _juzDao.getJuzInfo(i);

    if (juzInfo == null) {
      throw Exception("Juz $i not found!");
    }

    result.add(JuzInfoDto.fromEntity(juzInfo));
  }
  return result;
}

}