import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:mtqmnuns/data/local/db/app_database.dart';
import 'package:mtqmnuns/repositories/surah.dart';
import 'package:mtqmnuns/services/stt.dart';

class SttViewModel extends ChangeNotifier {
  final SttService _sttService;
  final SurahRepository _surahRepo;

  String transcription = "";
  bool isListening = false;
  bool isProcessing = false;
  SurahData? foundSurah;

  SttViewModel(this._sttService, this._surahRepo) {
    _sttService.transcriptionStream.listen(_onTranscription);
    _sttService.errorStream.listen(_onError);
  }

  Future<void> startListening() async {
    isListening = true;
    await _sttService.startListening();
    notifyListeners();
  }

  Future<void> stopListening() async {
    await _sttService.stopListening();
    _delayTimer?.cancel();
    _delayTimer = null;

    isProcessing = false;
    isListening = false;
    transcription = "";
    foundSurah = null;

    await _sttService.stopListening(); 
    notifyListeners();
  }

  Future<void> toggleListening() async {
    if (isListening) {
      await stopListening();
    } else {
      await startListening();
    }
  }

  void _onTranscription(String text) async {
    transcription = text;
    notifyListeners();

    if (!isProcessing) {
      isProcessing = true;

      final surah = await _surahRepo.fuzzyFindSurahFromText(text);
      foundSurah = surah;
      isProcessing = false;

      if (surah != null) {
        await _sttService.stopListening();
      } else {
        _retryListening();
      }

      notifyListeners();
    }
  }

  void _onError(String error) {
    _retryListening();
  }

  Timer? _delayTimer;
  Future<void> _retryListening() async {
    if (isProcessing) return;

    _delayTimer?.cancel();
    _delayTimer = Timer(Duration(seconds: 2), () {
      transcription = 'Coba Lagi';
      notifyListeners();
      Timer(Duration(milliseconds: 500), () {
        _sttService.startListening();
      });
    });
  }
}
