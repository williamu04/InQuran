import 'dart:async';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class SttService {
  final stt.SpeechToText _speech = stt.SpeechToText();
  final _transcriptionController = StreamController<String>.broadcast();
  final _errorController = StreamController<String>.broadcast();

  Stream<String> get transcriptionStream => _transcriptionController.stream;
  Stream<String> get errorStream => _errorController.stream;

  bool _hasSpeech = false;

  Future<void> initialize() async {
    try {
      _hasSpeech = await _speech.initialize(
        debugLogging: false,
        onError: (e) => _errorController.add(e.errorMsg),
      );
      if (_hasSpeech) {
        _speech.unexpectedPhraseAggregator = _punctAggregator;
      }
    } catch (e) {
      _hasSpeech = false;
      _errorController.add("Speech init failed: $e");
    }
  }

  Future<void> startListening({String locale = "id_ID"}) async {
    if (!_hasSpeech) await initialize();
    if (_hasSpeech && !_speech.isListening) {

      await _speech.listen(
        localeId: locale,
        onResult: (result) {
          _transcriptionController.add(result.recognizedWords);
        },
      );
    }
  }

  Future<void> stopListening() async {
    if (_speech.isListening) {
      await _speech.stop();
    }
  }

  void dispose() {
    _transcriptionController.close();
    _errorController.close();
    _speech.cancel();
  }

  String _punctAggregator(List<String> phrases) {
    return phrases.join('. ');
  }
}
