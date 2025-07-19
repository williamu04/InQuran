import 'dart:async';
import 'dart:typed_data';
import 'package:flutter_sound/flutter_sound.dart';

class MicService {
  final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  final StreamController<Uint8List> _audioStreamController = StreamController<Uint8List>.broadcast();

  bool _isInitialized = false;
  bool get isRecording => _recorder.isRecording;

  Future<void> initialize() async {
    if (_isInitialized) return;
    await _recorder.openRecorder();
    _isInitialized = true;
  }

  Stream<Uint8List> get audioStream {
    if (!_isInitialized || !_recorder.isRecording) {
      throw Exception('MicController is not initialized or not recording.');
    }
    return _audioStreamController.stream;
  }


  Future<void> start() async {
    if (!_isInitialized) await initialize();
    await _recorder.startRecorder(
      toStream: _audioStreamController.sink,
      codec: Codec.pcm16,
      numChannels: 1,
      sampleRate: 16000,
    );
  }

  Future<void> stop() async {
    if (_recorder.isRecording) {
      await _recorder.stopRecorder();
    }
  }

  Future<void> dispose() async {
    await stop();
    await _recorder.closeRecorder();
    await _audioStreamController.close();
  }
}
