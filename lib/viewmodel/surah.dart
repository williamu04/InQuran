import 'package:mtqmnuns/dto/surah.dart';
import 'package:mtqmnuns/repositories/ayah.dart';
import 'package:mtqmnuns/state/surah.dart';
import 'package:mtqmnuns/viewmodel/stateful_generic_helper.dart';


class SurahViewModel extends StatefulViewModel<SurahDetailState> {
  final AyahRepository _ayahRepo;

  SurahViewModel(this._ayahRepo) : super(SurahLoading());

  void _updateSuccess(List<AyahWithSurahDto> ayahs,
      {String? warning, int? jumpIndex}) {
    setState(SurahSuccess(ayahs, warning: warning, jumpIndex: jumpIndex));
  }

  Future<void> loadSurah(
    int startSurahId,
    int startSurahAyah,
    int endSurahId,
    int endSurahAyah,
  ) async {
    setState(SurahLoading());
    try {
      final data = await _ayahRepo.getAyahsInRange(
        startSurahId: startSurahId,
        startAyahNumber: startSurahAyah,
        endSurahId: endSurahId,
        endAyahNumber: endSurahAyah,
      );
      _updateSuccess(data);
    } catch (e) {
      setState(SurahError(e.toString()));
    }
  }

  Future<void> appendBySurah() async {
    if (state is! SurahSuccess) return;
    final ayahs = (state as SurahSuccess).ayahs;
    final last = ayahs.lastOrNull;
    if (last == null) {
      setState(SurahError("Internal Error(500)"));
      return;
    }
    if (last.surahNumber == 114) return;
    try {
      if (last.number < last.totalAyah) {
        final newAyahs = await _ayahRepo.getAyahsInRange(
          startSurahId: last.surahNumber, 
          startAyahNumber: last.number + 1,
          endSurahId: last.surahNumber, 
          endAyahNumber: last.totalAyah
        );
        _updateSuccess([...ayahs, ...newAyahs], jumpIndex: ayahs.length - 1);
      } else {
        final newAyahs = await _ayahRepo.getAyahsBySurahId(last.surahNumber + 1);
        _updateSuccess([...ayahs, ...newAyahs], jumpIndex: ayahs.length - 1);
      }
    } catch (e) {
      _updateSuccess(ayahs, warning: "Load Failed");
    }
  }

  Future<void> prependBySurah() async {
    if (state is! SurahSuccess) return;
    final ayahs = (state as SurahSuccess).ayahs;
    final first = ayahs.firstOrNull;
    if (first == null) {
      setState(SurahError("Internal Error(500)"));
      return;
    }
    if (first.surahNumber == 1) return;

    try {
      if (first.number > 1) {
        final newAyahs = await _ayahRepo.getAyahsInRange(
          startSurahId: first.surahNumber, 
          startAyahNumber: 1,
          endSurahId: first.surahNumber, 
          endAyahNumber: first.number - 1 
        );
        _updateSuccess([...ayahs, ...newAyahs], jumpIndex: ayahs.length - 1);
      } else {
        final newAyahs =
            await _ayahRepo.getAyahsBySurahId(first.surahNumber - 1);
        _updateSuccess([...newAyahs, ...ayahs], jumpIndex: newAyahs.length);
      }
    } catch (e) {
      _updateSuccess(ayahs, warning: "Load Failed");
    }
  }

  Future<void> appendByJuz() async {
    if (state is! SurahSuccess) return;
    final ayahs = (state as SurahSuccess).ayahs;
    final last = ayahs.lastOrNull;
    if (last == null) {
      setState(SurahError("Internal Error(500)"));
      return;
    }
    if (last.juzNumber == 30) return;

    try {
      final newAyahs = await _ayahRepo.getAyahsByJuz(last.juzNumber + 1);
      _updateSuccess([...ayahs, ...newAyahs], jumpIndex: ayahs.length - 1);
    } catch (e) {
      _updateSuccess(ayahs, warning: "Load Failed");
    }
  }

  Future<void> prependByJuz() async {
    if (state is! SurahSuccess) return;
    final ayahs = (state as SurahSuccess).ayahs;
    final first = ayahs.firstOrNull;
    if (first == null) {
      setState(SurahError("Internal Error(500)"));
      return;
    }
    if (first.juzNumber == 1) return;

    try {
      final newAyahs = await _ayahRepo.getAyahsByJuz(first.juzNumber - 1);
      _updateSuccess([...newAyahs, ...ayahs], jumpIndex: newAyahs.length);
    } catch (e) {
      _updateSuccess(ayahs, warning: "Load Failed");
    }
  }

  Future<void> appendSurahByCount(int count) async {
    if (state is! SurahSuccess) return;
    final ayahs = (state as SurahSuccess).ayahs;
    final first = ayahs.firstOrNull;
    if (first == null) {
      setState(SurahError("Internal Error(500)"));
      return;
    }
    if (first.surahNumber == 1) return;

    try {
      final newAyahs = await _ayahRepo.getPreviousAyahs(
        endSurahId: first.surahNumber,
        endAyahNumber: first.number,
        count: count,
      );
      _updateSuccess([...newAyahs, ...ayahs], jumpIndex: ayahs.length - 1);
    } catch (e) {
      _updateSuccess(ayahs, warning: "Load Failed");
    }
  }

  Future<void> prependSurahByCount(int count) async {
    if (state is! SurahSuccess) return;
    final ayahs = (state as SurahSuccess).ayahs;
    final last = ayahs.lastOrNull;
    if (last == null) {
      setState(SurahError("Internal Error(500)"));
      return;
    }
    if (last.surahNumber == 114) return;

    try {
      final newAyahs = await _ayahRepo.getNextAyahs(
        startSurahId: last.surahNumber,
        startAyahNumber: last.number,
        count: count,
      );
      _updateSuccess([...ayahs, ...newAyahs], jumpIndex: newAyahs.length);
    } catch (e) {
      _updateSuccess(ayahs, warning: "Load Failed");
    }
  }

  Future<void> loadByPage(int pageNumber) async {
    if (pageNumber < 1 || pageNumber > 604) {
      if (state is SurahSuccess) {
        setState(SurahSuccess((state as SurahSuccess).ayahs, warning: "sudah mencapai halaman terakhir"));
        return;
      } else {
        setState(SurahError("invalid halaman"));
      }
    }
    setState(SurahLoading());
    try {
      final data = await _ayahRepo.getAyahsByPage(pageNumber);
      _updateSuccess(data);
    } catch (e) {
      setState(SurahError(e.toString()));
    }
  }

  Future<void> loadPageByJuz(int juzNumber) async {
    if (juzNumber < 1 || juzNumber > 30) {
      if (state is SurahSuccess) {
        setState(SurahSuccess((state as SurahSuccess).ayahs, warning: "sudah mencapai juz terakhir"));
        return;
      } else {
        setState(SurahError("invalid juz"));
      }
    }
    setState(SurahLoading());
    try {
      final data = await _ayahRepo.getAyahsByFirstJuzPage(juzNumber);
      _updateSuccess(data);
    } catch (e) {
      setState(SurahError(e.toString()));
    }
  }

  Future<void> loadAyahsInPageOf(int surahId, int ayahNumber) async {
    if (surahId < 1 || surahId > 114) {
      if (state is SurahSuccess) {
        setState(SurahSuccess((state as SurahSuccess).ayahs, warning: "sudah mencapai surah terakhir"));
        return;
      } else {
        setState(SurahError("invalid surah"));
      }
    }
    setState(SurahLoading());
    try {
      final data = await _ayahRepo.getAyahsInPageOf(surahId, ayahNumber);
      _updateSuccess(data);
    } catch (e) {
      setState(SurahError(e.toString()));
    }
  }

  Future<void> loadAllAyahs() async {
    setState(SurahLoading());
    try {
      final data = await _ayahRepo.getAllAyahWithSurah();
      _updateSuccess(data);
    } catch (e) {
      setState(SurahError(e.toString()));
    }
  }
}
