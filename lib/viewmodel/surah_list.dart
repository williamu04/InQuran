import 'package:inquran/dto/juz.dart';
import 'package:inquran/dto/surah.dart';
import 'package:inquran/repositories/juz.dart';
import 'package:inquran/repositories/surah.dart';
import 'package:inquran/services/surah_filter.dart';
import 'package:inquran/state/surah_list.dart';
import 'package:inquran/state/stateful_viewmodel.dart';

class SurahListViewModel extends StatefulViewModel<SurahListState> {
  final SurahRepository _surahRepo;
  final JuzRepository _juzRepo;
  final SurahFilterService _filterService;

  String _query = '';
  List<SurahInfoDto> _allSurahs = [];
  List<JuzInfoDto> _allJuz = [];

  SurahContentType _contentType = SurahContentType.surah;
  SurahContentType get contentType => _contentType;

  SurahListViewModel(
    this._surahRepo,
    this._filterService,
    this._juzRepo,
  ) : super(SurahListLoading()) {
    _initializeData();
  }

  Future<void> _initializeData() async {
    setState(SurahListLoading());

    try {
      _allSurahs = await _surahRepo.getAllSurahs();
      _allJuz = await _juzRepo.getAllJuz();

      if (_contentType == SurahContentType.surah) {
        setState(SurahListSuccessTypeSurah(surahs: _allSurahs));
      } else {
        setState(SurahListSuccessTypeJuz(juz: _allJuz));
      }
    } catch (e) {
      setState(SurahListError("Gagal memuat data Al-Qur'an: $e"));
    }
  }

  void updateSearchQuery(String query) {
    _query = query;

    if (_contentType == SurahContentType.surah) {
      if (_allSurahs.isEmpty) {
        setState(SurahListError("Terjadi kesalahan saat memuat data surah"));
        return;
      }

      final filteredSurahs = _filterService.filterSurahs(_allSurahs, query);

      if (filteredSurahs.isEmpty) {
        setState(SurahListSuccessEmpty());
      } else {
        setState(SurahListSuccessTypeSurah(surahs: filteredSurahs));
      }
    } else {
      if (_allJuz.isEmpty) {
        setState(SurahListError("Terjadi kesalahan saat memuat data juz"));
        return;
      }

      final filteredJuz = _filterService.filterJuz(_allJuz, query);

      if (filteredJuz.isEmpty) {
        setState(SurahListSuccessEmpty());
      } else {
        setState(SurahListSuccessTypeJuz(juz: filteredJuz));
      }
    }
  }

  void setContentType(SurahContentType contentType) {
    _contentType = contentType;
    updateSearchQuery(_query); 
  }
}
