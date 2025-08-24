import 'package:flutter/material.dart';
import 'package:mtqmnuns/data/local/db/app_database.dart';

import 'package:flutter/foundation.dart';
import 'package:mtqmnuns/models/juz.dart';
import 'package:mtqmnuns/models/surah.dart';
import 'package:mtqmnuns/screens/surah_list.dart';

class SurahListViewModel extends ChangeNotifier {
  final AppDatabase _database = AppDatabase();
  
  // Search functionality
  String _searchQuery = '';
  String get searchQuery => _searchQuery;

  // Loading state
  bool _isLoading = true;
  bool get isLoading => _isLoading;

  // Data storage
  List<SurahWithVerse> _allSurahsWithVerse = [];
  List<JuzInfo> _allJuzData = [];

  // Filtered data (public getters)
  List<SurahWithVerse> filteredSurahs = [];
  List<JuzInfo> filteredJuz = [];

  String _currentContentFilter = 'surah'; 

  SurahListViewModel() {
    _initializeData();
  }

  // Public methods
  void updateSearchQuery(String query) {
    _searchQuery = query;
    _applyFilters();
  }

  void setContentFilter(SurahContentType contentType) {
    if (contentType == SurahContentType.surah) {
      _currentContentFilter = 'surah';
    } else if (contentType == SurahContentType.juz) {
      _currentContentFilter = 'juz';
    }
    _applyFilters();
  }

  // Private methods
  Future<void> _initializeData() async {
    _isLoading = true;
    notifyListeners();

    try {
      _allSurahsWithVerse = await _database.surahDao.getAllSurahsWithVerseCount();
      _allJuzData = await _database.juzDao.getAllJuzInfo();
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
      _resetToAllData();
    } else {
      _filterBySearchQuery(query);
    }

    notifyListeners();
  }

  void _resetToAllData() {
    filteredSurahs = List.from(_allSurahsWithVerse);
    filteredJuz = List.from(_allJuzData);
  }

  void _filterBySearchQuery(String query) {
    if (_currentContentFilter == 'surah') {
      _filterSurahs(query);
    } else {
      _filterJuz(query);
    }
  }

  void _filterSurahs(String query) {
    filteredSurahs = _allSurahsWithVerse.where((surahVerse) {
      return _surahMatchesQuery(surahVerse.surah, query);
    }).toList();
  }

  bool _surahMatchesQuery(SurahData surah, String query) {
    return surah.nameLatin.toLowerCase().contains(query) ||
           surah.place.toLowerCase().contains(query) ||
           surah.name.toLowerCase().contains(query) ||
           surah.id.toString().contains(query);
  }

  void _filterJuz(String query) {
    filteredJuz = _allJuzData.where((juz) {
      return _juzMatchesQuery(juz, query);
    }).toList();
  }

  bool _juzMatchesQuery(JuzInfo juz, String query) {
    final juzLabel = 'juz ${juz.juzNumber}';
    
    
    return juz.juzNumber.toString().contains(query) ||
           juzLabel.contains(query) ||
           _surahDataMatchesQuery(juz.startSurah, query) ||
           _surahDataMatchesQuery(juz.endSurah, query);
  }

  bool _surahDataMatchesQuery(dynamic surahData, String query) {
    if (surahData == null) return false;
    
    final nameLatin = (surahData.nameLatin ?? '').toLowerCase();
    final nameArabic = (surahData.name ?? '').toLowerCase();
    
    return nameLatin.contains(query) || nameArabic.contains(query);
  }

  @override
  void dispose() {
    super.dispose();
  }
}
