import 'package:flutter/material.dart';
import 'package:mtqmnuns/dto/mushaf.dart';
import 'package:mtqmnuns/dto/surah.dart';
import 'package:mtqmnuns/repositories/ayah.dart';
import 'package:mtqmnuns/state/mushaf.dart';

class MushafViewModel extends ChangeNotifier {
  final AyahRepository _ayahRepo;
  int pageNumber = 1;
  List<List<MushafPagesItem>> _pages = [];
  MushafState _state = MushafInit();
  MushafState get state => _state;
  
  int? initSurah;
  int? initAyah;


  MushafViewModel(this._ayahRepo);

  void init(int surahId, int ayahNumber) {
    initSurah = surahId;
    initAyah = ayahNumber;
  }

  Future<void> loadPagination(TextStyle style, double pageWidth, double pageHeight) async {
    _state = MushafLoading();
    try {
      final ayahs = await _ayahRepo.getAllAyahWithSurah();
      _pages = _paginateAyahs(ayahs, style, pageWidth, pageHeight);
      _state = MushafPageLoaded(_pages[0], 1);
      notifyListeners();
    } catch (e) {
      _state = MushafError(e.toString());
      notifyListeners();
    }
  }

  void goToPage(int pageNumber) {
    if (_state is! MushafPageLoaded) return; 
    if (pageNumber < 1 || pageNumber > _pages.length) return; 

    final pageItems = _pages[pageNumber - 1]; 
    _state = (_state as MushafPageLoaded).copyWith(
      pageNumber: pageNumber,
      pageItems: pageItems,
    );

    notifyListeners();
  }

  void nextPage() {
    if (_state is! MushafPageLoaded) return;
    final current = _state as MushafPageLoaded;
    if (current.pageNumber >= _pages.length) return;

    goToPage(current.pageNumber + 1);
  }

  void previousPage() {
    if (_state is! MushafPageLoaded) return;
    final current = _state as MushafPageLoaded;
    if (current.pageNumber <= 1) return;

    goToPage(current.pageNumber - 1);
  }



   Size _measureText(String text, TextStyle style, double maxWidth) {
    final tp = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
      maxLines: null,
    )..layout(maxWidth: maxWidth);

    return Size(tp.width, tp.height);
  }

  TextStyle _fitTextToPage(String text, TextStyle baseStyle, double maxWidth, double maxHeight) {
    final baseFontSize = baseStyle.fontSize ?? 15;
    double fontSize = baseFontSize;
    
    // Try reducing font size if text is too big
    for (int attempts = 0; attempts < 10; attempts++) {
      final testStyle = baseStyle.copyWith(fontSize: fontSize);
      final size = _measureText(text, testStyle, maxWidth);
      
      if (size.height <= maxHeight || fontSize <= 8) {
        return testStyle;
      }
      
      fontSize *= 0.9; // Reduce by 10% each time
    }
    
    return baseStyle.copyWith(fontSize: 8); // Minimum fallback
  }

  List<List<MushafPagesItem>> _paginateAyahs(
    List<AyahWithSurahDto> ayahs,
    TextStyle baseStyle,
    double pageWidth,
    double pageHeight,
  ) {
    final pages = <List<MushafPagesItem>>[];
    var currentPage = <MushafPagesItem>[];
    double usedHeight = 0;

    for (final ayah in ayahs) {
      if (ayah.surahNumber == 1) continue;
      final marker = "۝${_toArabicNumeral(ayah.number)}";
      final ayahWithMarker = '${ayah.arabText} $marker '; 
      if (ayah.number == 1 && ayah.surahNumber != 9) { 
        final bismillah = "بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ";
        final bismillahStyle = _fitTextToPage(bismillah, baseStyle, pageWidth, pageHeight);
        final bismillahSize = _measureText(bismillah, bismillahStyle, pageWidth);

        if (usedHeight + bismillahSize.height > pageHeight) {
          pages.add(currentPage);
          currentPage = [];
          usedHeight = 0;
        }

        currentPage.add(MushafPagesItem(bismillah, bismillahStyle, bismillahSize, ayah));
        usedHeight += bismillahSize.height;
      }

      final ayahStyle = _fitTextToPage(ayahWithMarker, baseStyle, pageWidth, pageHeight);
      final ayahSize = _measureText(ayahWithMarker, ayahStyle, pageWidth);

      if (usedHeight + ayahSize.height > pageHeight) {
        pages.add(currentPage);
        currentPage = [];
        usedHeight = 0;
      }

      currentPage.add(MushafPagesItem(ayahWithMarker, ayahStyle, ayahSize, ayah));
      usedHeight += ayahSize.height;
    }

    if (currentPage.isNotEmpty) {
      pages.add(currentPage);
    }

    return pages;
  }

  String _toArabicNumeral(int number) {
  const arabicDigits = ['٠','١','٢','٣','٤','٥','٦','٧','٨','٩'];
  final str = number.toString();
  return str.split('').map((d) => arabicDigits[int.parse(d)]).join();
}

}
