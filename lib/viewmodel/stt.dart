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
    _bindStreams();
  }

  void _bindStreams() {
    _sttService.finalResultStream.listen(_onFinalTranscription);
    _sttService.errorStream.listen((message) async {
      if (message == 'error_network' || message =='error_network_timeout') {
      }
      if (_state is! SttIdle){
        await startListening();
      }
    });
  }

  void _onFinalTranscription(String text) async {
    _state = SttProcessing(text);
    notifyListeners();

    try {
      final surah = await _surahRepo.fuzzyFindSurahFromText(text);
      await _sttService.stopListening();
      if (_state is SttProcessing) _state = SttSuccess(surah);
    } catch (_) {
      if (_state is SttProcessing) _retryListening();
    }

    notifyListeners();
  }

  Future<void> startListening() async {
    if(_state is SttListening) return;
    await _sttService.startListening();
    _state = SttListening(_sttService.transcriptionStream);
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
    if (_state is SttIdle) {
      await startListening();
    } else {
      await stopListening();
    }
  }

  void _retryListening() {
    _delayTimer?.cancel();
    if (_state is SttIdle) return;
    _delayTimer = Timer(const Duration(seconds: 2), () {
      if (_state is SttIdle) return;
      _state = SttRetry();
      notifyListeners();

      Timer(const Duration(milliseconds: 500), () async {
        if (_state is SttIdle) return;
        await startListening();
      });
    });
  }
}
