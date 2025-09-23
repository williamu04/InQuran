import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:mtqmnuns/repositories/surah.dart';
import 'package:mtqmnuns/services/stt.dart';
import 'package:mtqmnuns/state/stt.dart';
import 'package:mtqmnuns/viewmodel/stateful_generic_helper.dart';

class SttViewModel extends StatefulViewModel<SttState> {
  final SttService _sttService;
  final SurahRepository _surahRepo;

  Timer? _delayTimer;

  SttViewModel(this._sttService, this._surahRepo) : super(SttIdle()) {
    _bindStreams();
  }

  void _bindStreams() {
    _sttService.finalResultStream.listen(_onFinalTranscription);
    _sttService.errorStream.listen((message) async {
      final trimmed = message.trim();
      if (trimmed == 'error_network' || trimmed == 'error_network_timeout') {
        debugPrint(trimmed);
        setState(SttNetworkError());
        return;
      }
      if (state is! SttIdle) {
        await startListening();
      }
    });
  }

  void changeStateToIdle() {
    setState(SttIdle());
  }

  void _onFinalTranscription(String text) async {
    setState(SttProcessing(text));

    try {
      final surah = await _surahRepo.fuzzyFindSurahFromText(text);
      await _sttService.stopListening();
      if (state is SttProcessing) setState(SttSuccess(surah));
    } catch (_) {
      if (state is SttProcessing) _retryListening();
    }
  }

  Future<void> startListening() async {
    if (state is SttListening) return;
    await _sttService.startListening();
    setState(SttListening(_sttService.transcriptionStream));
  }

  Future<void> stopListening() async {
    await _sttService.stopListening();
    _delayTimer?.cancel();
    _delayTimer = null;
    setState(SttIdle());
  }

  Future<void> toggleListening() async {
    if (state is SttIdle) {
      await startListening();
    } else {
      await stopListening();
    }
  }

  void _retryListening() {
    _delayTimer?.cancel();
    if (state is SttIdle) return;

    _delayTimer = Timer(const Duration(seconds: 2), () {
      if (state is SttIdle) return;
      setState(SttRetry());

      Timer(const Duration(milliseconds: 500), () async {
        if (state is! SttRetry) return;
        await startListening();
      });
    });
  }
}
