import 'package:flutter/material.dart';

import 'package:flutter/foundation.dart';
import 'package:mtqmnuns/dto/juz.dart';
import 'package:mtqmnuns/dto/surah.dart';
import 'package:mtqmnuns/repositories/juz.dart';
import 'package:mtqmnuns/repositories/surah.dart';
import 'package:mtqmnuns/services/surah_filter.dart';
import 'package:mtqmnuns/state/surah_list.dart';

class SurahListViewModel extends ChangeNotifier {
  final SurahRepository _surahRepo;
  final JuzRepository _juzRepo;
  final SurahFilterService _filterService;
  String _query = '';

  List<SurahInfoDto> _allSurahs = [];
  List<JuzInfoDto> _allJuz = [];

  SurahContentType _contentType = SurahContentType.surah;
  SurahContentType get contentType => _contentType;

  SurahListState _state = SurahListLoading();
  SurahListState get state => _state;

  SurahListViewModel(
    this._surahRepo,
    this._filterService,
    this._juzRepo,
  ) {
    _initializeData();
  }

  Future<void> _initializeData() async {
    _state = SurahListLoading();
    notifyListeners();

    try {
      _allSurahs = await _surahRepo.getAllSurahs();
      _allJuz = await _juzRepo.getAllJuz();
      if (_contentType == SurahContentType.surah) {
        _state = SurahListSuccessTypeSurah(surahs: _allSurahs);
      } else {
        _state = SurahListSuccessTypeJuz(juz: _allJuz);
      }
    } catch (e) {
      _state = SurahListError('Error loading Quran data: $e');
    }

    notifyListeners();
  }

  void updateSearchQuery(String query) {
    _query = query;
    if (_contentType == SurahContentType.surah) {
      if (_allSurahs.isEmpty) {
        _state = SurahListError("somethign wrong when loading surah data");
      }
      final filteredSurahs = _filterService.filterSurahs(_allSurahs, query);

      if (filteredSurahs.isEmpty) {
        _state = SurahListSuccessEmpty();
        notifyListeners();
        return;
      }
      _state = SurahListSuccessTypeSurah(surahs: filteredSurahs);
    } else {
      if (_allJuz.isEmpty) {
        _state = SurahListError("somethign wrong when loading juz data");
      }
      final filteredJuz = _filterService.filterJuz(_allJuz, query);

      if (filteredJuz.isEmpty) {
        _state = SurahListSuccessEmpty();
        notifyListeners();
        return;
      }
      _state = SurahListSuccessTypeJuz(juz: filteredJuz);
    }
    notifyListeners();
  }

  void setContentType(SurahContentType contentType) {
    _contentType = contentType; 
    notifyListeners();
    updateSearchQuery(_query);
  }
}
