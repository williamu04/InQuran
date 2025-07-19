import 'package:flutter/material.dart';
import 'package:mtqmnuns/services/stt_service.dart';

class TranscriptionViewModel extends ChangeNotifier {
  final SttService stt;
  String _transcript = '';

  String get transcript => _transcript;

  TranscriptionViewModel(this.stt) {
  }

  void startTranscription() => stt.startListening();

  void stopTranscription() => stt.stopListening();

  void clearTranscript() {
    _transcript = '';
    notifyListeners();
  }

  @override
  void dispose() {
    stt.dispose();
    super.dispose();
  }
}
