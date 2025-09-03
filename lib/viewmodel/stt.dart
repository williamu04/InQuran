import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:mtqmnuns/repositories/surah.dart';
import 'package:mtqmnuns/services/stt.dart';
import 'package:mtqmnuns/state/stt.dart';

class SttViewModel extends ChangeNotifier {
  final SttService _sttService;
  final SurahRepository _surahRepo;

  SttState _state = SttIdle();
  SttState get state => _state;

  Timer? _delayTimer;

  SttViewModel(this._sttService, this._surahRepo) {
    _sttService.transcriptionStream.listen(_onTranscription);
    _sttService.errorStream.listen(_onError);
  }

  Future<void> startListening() async {
    _state = SttListening("");
    await _sttService.startListening();
    notifyListeners();
  }

  Future<void> stopListening() async {
    await _sttService.stopListening();
    _delayTimer?.cancel();
    _delayTimer = null;
    _state = SttIdle();
    notifyListeners();
  }

  Future<void> toggleListening() async {
    if (_state is SttListening || _state is SttProcessing) {
      await stopListening();
    } else {
      await startListening();
    }
  }

  void _onTranscription(String text) async {
    if (_state is! SttListening) return;

    _state = SttProcessing(text);
    notifyListeners();

    final surah = await _surahRepo.fuzzyFindSurahFromText(text);
    try {
      await _sttService.stopListening();
      _state = SttSuccess(surah);
    } catch (e) {
      _retryListening();
    }

    notifyListeners();
  }

  void _onError(String error) {
    _state = SttError(error);
    notifyListeners();
    _retryListening();
  }

  void _retryListening() {
    _delayTimer?.cancel();
    _delayTimer = Timer(const Duration(seconds: 2), () {
      _state = SttRetry("Coba Lagi");
      notifyListeners();

      Timer(const Duration(milliseconds: 500), () {
        _sttService.startListening();
        _state = SttListening("");
        notifyListeners();
      });
    });
  }
}
