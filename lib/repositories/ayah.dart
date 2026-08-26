import 'package:inquran/data/local/dao/ayah_dao.dart';
import 'package:inquran/dto/surah.dart';

class AyahRepository {
  final AyahDao _ayahDao;

  AyahRepository(this._ayahDao);

  Future<List<AyahWithSurahDto>> getAllAyahWithSurah() async {
    final entities = await _ayahDao.getSurahWithAyah();

    return entities
        .map((entity) => AyahWithSurahDto.fromEntity(entity))
        .toList();
  }

  Future<bool?> toggleFavorite(int surahId, int ayahNumber) async {
    return await _ayahDao.toggleFavoriteBySurahAndAyah(surahId, ayahNumber);
  }

  Future<List<AyahWithSurahDto>> getAyahsInRange({
    required int startSurahId,
    required int startAyahNumber,
    required int endSurahId,
    required int endAyahNumber,
  }) async {
    if (startSurahId < 1 ||
        endSurahId < 1 ||
        startAyahNumber < 1 ||
        endAyahNumber < 1) {
      throw Exception("Invalid surah or ayah numbers (400)");
    }

    if (startSurahId > endSurahId ||
        (startSurahId == endSurahId && startAyahNumber > endAyahNumber)) {
      throw Exception(
        "Invalid range: start position is after end position (400)",
      );
    }

    await _validateAyahExists(
      startSurahId,
      startAyahNumber,
      "Start ayah not found",
    );
    await _validateAyahExists(endSurahId, endAyahNumber, "End ayah not found");

    final entities = await _ayahDao.getAyahsInLogicalRange(
      startSurahId,
      startAyahNumber,
      endSurahId,
      endAyahNumber,
    );

    return entities
        .map((entity) => AyahWithSurahDto.fromEntity(entity))
        .toList();
  }

  Future<void> _validateAyahExists(
    int surahId,
    int ayahNumber,
    String errorMessage,
  ) async {
    final exists = await _ayahDao.ayahExists(surahId, ayahNumber);
    if (!exists) {
      throw Exception("$errorMessage (404)");
    }
  }

  Future<List<AyahWithSurahDto>> getAyahsBySurahId(int surahId) async {
    final entities = await _ayahDao.getAyahWithSurahBySurahId(surahId);
    if (entities.isEmpty) {
      throw Exception("ayah not found (500)");
    }
    return entities
        .map((entity) => AyahWithSurahDto.fromEntity(entity))
        .toList();
  }

  Future<List<AyahWithSurahDto>> getAyahsByJuz(int juz) async {
    final entities = await _ayahDao.getAyahWithSurahByJuz(juz);
    if (entities.isEmpty) {
      throw Exception("ayah not found (500)");
    }
    return entities
        .map((entity) => AyahWithSurahDto.fromEntity(entity))
        .toList();
  }

  Future<List<AyahWithSurahDto>> getNextAyahs({
    required int startSurahId,
    required int startAyahNumber,
    required int count,
  }) async {
    if (startSurahId < 1 || startAyahNumber < 1 || count < 1) {
      throw Exception("Invalid parameters: all values must be positive (400)");
    }

    await _validateAyahExists(
      startSurahId,
      startAyahNumber,
      "Start ayah not found",
    );
    final entities = await _ayahDao.getNextAyahsFromPosition(
      startSurahId,
      startAyahNumber,
      count,
    );
    return entities
        .map((entity) => AyahWithSurahDto.fromEntity(entity))
        .toList();
  }

  Future<List<AyahWithSurahDto>> getPreviousAyahs({
    required int endSurahId,
    required int endAyahNumber,
    required int count,
  }) async {
    if (endSurahId < 1 || endAyahNumber < 1 || count < 1) {
      throw Exception("Invalid parameters: all values must be positive (400)");
    }

    await _validateAyahExists(endSurahId, endAyahNumber, "End ayah not found");
    final entities = await _ayahDao.getPreviousAyahsBeforePosition(
      endSurahId,
      endAyahNumber,
      count,
    );
    return entities
        .map((entity) => AyahWithSurahDto.fromEntity(entity))
        .toList();
  }

  Future<List<AyahWithSurahDto>> getAyahsByPage(int pageNumber) async {
    if (pageNumber < 1 || pageNumber > 604) {
      throw Exception("Invalid page number (400)");
    }

    final entities = await _ayahDao.getAyahsByPage(pageNumber);
    return entities
        .map((entity) => AyahWithSurahDto.fromEntity(entity))
        .toList();
  }

  Future<List<AyahWithSurahDto>> getAyahsInPageOf(
    int surahId,
    int ayahNumber,
  ) async {
    if (surahId < 1 || surahId > 114) {
      throw Exception("Invalid surah id (400)");
    }
    await _validateAyahExists(surahId, ayahNumber, "Start ayah not found");
    final entities = await _ayahDao.getPageBySurahAndAyah(surahId, ayahNumber);
    return entities
        .map((entity) => AyahWithSurahDto.fromEntity(entity))
        .toList();
  }

  Future<List<AyahWithSurahDto>> getAyahsByFirstJuzPage(int juzNumber) async {
    if (juzNumber < 1 || juzNumber > 30) {
      throw Exception("Invalid juz number (400)");
    }

    final entities = await _ayahDao.getFirstPageByJuz(juzNumber);
    return entities
        .map((entity) => AyahWithSurahDto.fromEntity(entity))
        .toList();
  }
}
