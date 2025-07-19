import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class SttService {
  final stt.SpeechToText _speech = stt.SpeechToText();
  final _transcriptionController = StreamController<String>.broadcast();
  final String lang = "id_ID";
  
  Stream<String> get transcriptionStream => _transcriptionController.stream;
  
  bool _hasSpeech = false;
  bool _manuallyStopped = false;
  Timer? _delayTimer;
  
  Future<void> initialize() async {
    try {
      _hasSpeech = await _speech.initialize(
        onError: (e) => debugPrint("Speech error: $e"),
        debugLogging: false,
        onStatus: (status) {
          debugPrint("Speech status: $status");
          if (status == 'done' && !_manuallyStopped) {
            _handleSpeechDone();
          }
        }
      );
      if (_hasSpeech) {
        _speech.unexpectedPhraseAggregator = _punctAggregator;
      }
    } catch (e) {
      debugPrint('Speech init failed: $e');
      _hasSpeech = false;
    }
  }
  
  void _handleSpeechDone() {
    _delayTimer?.cancel();
    
    _delayTimer = Timer(Duration(seconds: 2), () {
      _transcriptionController.add('Coba Lagi');
      Timer(Duration(milliseconds: 500), () {
        startListening();
      });
    });
  }
  
  void startListening() async {
    if (!_hasSpeech) await initialize();
    if (_hasSpeech && !_speech.isListening) {
      _manuallyStopped = false;
      _delayTimer?.cancel();
      
      await _speech.listen(
        localeId: lang,
        onResult: (result) async {
          String currentText = result.recognizedWords;
          _transcriptionController.add(currentText);
          
          if (result.finalResult) {
          }
        }
      );
    }
  }
  
  void stopListening() async {
    _manuallyStopped = true;
    _delayTimer?.cancel(); 
    if (_speech.isListening) {
      await _speech.stop();
    }
  }
  
  void dispose() {
    _delayTimer?.cancel();
    _transcriptionController.close();
    _speech.cancel();
  }
  
  String _punctAggregator(List<String> phrases) {
    return phrases.join('. ');
  }
}