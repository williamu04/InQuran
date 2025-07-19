import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mtqmnuns/services/stt_service.dart';

class TranscriptionViewModel extends ChangeNotifier {
  final SttService stt;
  String _transcript = '';
  Timer? _debounce;

  String get transcript => _transcript;

  TranscriptionViewModel(this.stt) {
    stt.transcriptionStream.listen((text) {
      if (text.trim().isNotEmpty) {
        _transcript = text.trim(); 
        notifyListeners();
      }
    });
  }

  void startTranscription() => stt.startListening();

  void stopTranscription() => stt.stopListening();

  void clearTranscript() {
    _transcript = '';
    notifyListeners();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    stt.dispose();
    super.dispose();
  }
}
