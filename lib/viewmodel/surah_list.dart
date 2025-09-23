import 'package:flutter/material.dart';

import 'package:flutter/foundation.dart';
import 'package:mtqmnuns/dto/juz.dart';
import 'package:mtqmnuns/dto/surah.dart';
import 'package:mtqmnuns/repositories/juz.dart';
import 'package:mtqmnuns/repositories/surah.dart';
import 'package:mtqmnuns/services/surah_filter.dart';
import 'package:mtqmnuns/state/surah_list.dart';
import 'package:mtqmnuns/viewmodel/stateful_generic_helper.dart';

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
      setState(SurahListError('Error loading Quran data: $e'));
    }
  }

  void updateSearchQuery(String query) {
    _query = query;

    if (_contentType == SurahContentType.surah) {
      if (_allSurahs.isEmpty) {
        setState(SurahListError("Something went wrong when loading surah data"));
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
        setState(SurahListError("Something went wrong when loading juz data"));
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
