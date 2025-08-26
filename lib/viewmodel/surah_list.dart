import 'package:flutter/material.dart';
import 'package:mtqmnuns/data/local/db/app_database.dart';

import 'package:flutter/foundation.dart';
import 'package:mtqmnuns/models/juz.dart';
import 'package:mtqmnuns/models/surah.dart';
import 'package:mtqmnuns/repositories/surah.dart';
import 'package:mtqmnuns/screens/surah_list.dart';
import 'package:mtqmnuns/services/surah_filter.dart';

class SurahListViewModel extends ChangeNotifier {
  final SurahRepository _surahRepo;
  final SurahFilterService _filterService;

  // Search state
  String _searchQuery = '';
  String get searchQuery => _searchQuery;

  // Loading state
  bool _isLoading = true;
  bool get isLoading => _isLoading;

  // Raw data
  List<SurahWithVerseCount> _allSurahsWithVerse = [];
  List<JuzInfo> _allJuzData = [];

  // Filtered data (exposed to UI)
  List<SurahWithVerseCount> filteredSurahs = [];
  List<JuzInfo> filteredJuz = [];

  // Content filter (surah or juz)
  String _currentContentFilter = 'surah'; 

  SurahListViewModel(this._surahRepo, this._filterService) {
    _initializeData();
  }

  // Public API
  void updateSearchQuery(String query) {
    _searchQuery = query;
    _applyFilters();
  }

  void setContentFilter(SurahContentType contentType) {
    _currentContentFilter = 
      contentType == SurahContentType.surah ? 'surah' : 'juz';
    _applyFilters();
  }

  // Private methods
  Future<void> _initializeData() async {
    _isLoading = true;
    notifyListeners();

    try {
      _allSurahsWithVerse = await _surahRepo.getAllSurahsWithVerseCount();
      _allJuzData = await _surahRepo.getAllJuzInfo();
      _applyFilters();
    } catch (e) {
      debugPrint('Error loading Quran data: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void _applyFilters() {
    final query = _searchQuery.toLowerCase().trim();

    if (query.isEmpty) {
      filteredSurahs = List.from(_allSurahsWithVerse);
      filteredJuz = List.from(_allJuzData);
    } else {
      if (_currentContentFilter == 'surah') {
        filteredSurahs = _filterService.filterSurahs(_allSurahsWithVerse, query);
      } else {
        filteredJuz = _filterService.filterJuz(_allJuzData, query);
      }
    }

    notifyListeners();
  }
}

