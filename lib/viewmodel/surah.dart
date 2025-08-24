import 'package:flutter/material.dart';
import 'package:mtqmnuns/data/local/db/app_database.dart';

import 'package:flutter/foundation.dart';
import 'package:mtqmnuns/screens/surah_list.dart';

class SurahViewModel extends ChangeNotifier {
  final AppDatabase _database = AppDatabase();
  
  // Search functionality
  String _searchQuery = '';
  String get searchQuery => _searchQuery;

  // Loading state
  bool _isLoading = true;
  bool get isLoading => _isLoading;

  // Data storage
  List<SurahData> _allSurahs = [];
  List<Map<String, dynamic>> _allJuzData = [];
  Map<int, int> _surahVerseCounts = {};

  // Filtered data (public getters)
  List<SurahData> filteredSurahs = [];
  List<Map<String, dynamic>> filteredJuz = [];

  String _currentContentFilter = 'surah'; 

  SurahViewModel() {
    _initializeData();
  }

  // Public methods
  int getVerseCount(int surahId) {
    return _surahVerseCounts[surahId] ?? 0;
  }

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
      await _loadSurahData();
      await _loadJuzData();
      await _calculateVerseCounts();
      _applyFilters();
    } catch (e) {
      debugPrint('Error loading Quran data: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _loadSurahData() async {
    _allSurahs = await _database.surahDao.getAllSurahs();
  }

  Future<void> _loadJuzData() async {
    _allJuzData = await _database.juzDao.getJuzInfo(_database.surahDao);
  }

  Future<void> _calculateVerseCounts() async {
    final verseCountFutures = _allSurahs.map((surah) async {
      final ayahs = await _database.ayahDao.getAyahsBySurahId(surah.id);
      return MapEntry(surah.id, ayahs.length);
    });

    final verseCounts = await Future.wait(verseCountFutures);
    _surahVerseCounts = Map.fromEntries(verseCounts);
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
    filteredSurahs = List.from(_allSurahs);
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
    filteredSurahs = _allSurahs.where((surah) {
      return _surahMatchesQuery(surah, query);
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

  bool _juzMatchesQuery(Map<String, dynamic> juz, String query) {
    final juzNumber = juz['juz'].toString();
    final juzLabel = 'juz $juzNumber';
    
    final startSurah = juz['startSurah'];
    final endSurah = juz['endSurah'];
    
    return juzNumber.contains(query) ||
           juzLabel.contains(query) ||
           _surahDataMatchesQuery(startSurah, query) ||
           _surahDataMatchesQuery(endSurah, query);
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
