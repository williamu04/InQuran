import 'dart:math' as Math;

import 'package:flutter/material.dart';
import 'package:fuzzywuzzy/fuzzywuzzy.dart';
import 'package:mtqmnuns/data/local/db/app_database.dart';

enum SurahViewMode { surah, juz }

class BookViewModel extends ChangeNotifier {
  final AppDatabase _db = AppDatabase();
  String _searchQuery = '';
  String get searchQuery => _searchQuery;

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  SurahViewMode _currentMode = SurahViewMode.surah;
  SurahViewMode get currentMode => _currentMode;

  List<SurahData> _allSurahs = [];
  List<Map<String, dynamic>> _allJuz = [];

  List<SurahData> filteredSurahs = [];
  List<Map<String, dynamic>> filteredJuz = [];

  Map<int, int> _verseCounts = {};
  int getVerseCount(int surahId) {
    return _verseCounts[surahId] ?? 0;
  }

  BookViewModel() {
    loadData();
  }

  void setSearchQuery(String value) {
    _searchQuery = value;
    filterData();
  }

  void switchMode(SurahViewMode mode) {
    _currentMode = mode;
    filterData();
    notifyListeners();
  }

  Future<void> loadData() async {
    _isLoading = true;
    notifyListeners();

    _allSurahs = await _db.surahDao.getAllSurahs();
    _allJuz = await _db.juzDao.getJuzInfo(_db.surahDao);

    final counts = await Future.wait(
      _allSurahs.map((s) async {
        final ayahs = await _db.ayahDao.getAyahsBySurahId(s.id);
        return MapEntry(s.id, ayahs.length);
      }),
    );
    _verseCounts = Map.fromEntries(counts);
    filterData();
    _isLoading = false;
    notifyListeners();
  }


  void filterData() {
    final query = _searchQuery.toLowerCase();

    if (query.isEmpty) {
      filteredSurahs = List.from(_allSurahs);
      filteredJuz = List.from(_allJuz);
      notifyListeners();
      return;
    }

    if (currentMode == SurahViewMode.surah) {
      filteredSurahs = _allSurahs.where((s) =>
        s.nameLatin.toLowerCase().contains(query) ||
        s.place.toLowerCase().contains(query) ||
        s.name.toLowerCase().contains(query) ||
        '${s.id}'.contains(query)
      ).toList();
    }

    if (currentMode == SurahViewMode.juz) {
      filteredJuz = _allJuz.where((j) {
        final juzNumber = '${j['juz']}';
        final juzLabel = 'juz $juzNumber';

        final startSurahLatin = (j['startSurah']?.nameLatin ?? '').toLowerCase();
        final endSurahLatin = (j['endSurah']?.nameLatin ?? '').toLowerCase();
        final startSurahArabic = (j['startSurah']?.name ?? '').toLowerCase();
        final endSurahArabic = (j['endSurah']?.name ?? '').toLowerCase();

        return juzNumber.contains(query) ||
            juzLabel.contains(query) || 
            startSurahLatin.contains(query) ||
            endSurahLatin.contains(query) ||
            startSurahArabic.contains(query) ||
            endSurahArabic.contains(query);
      }).toList();
    }

    notifyListeners();
  }

}