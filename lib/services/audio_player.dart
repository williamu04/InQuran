import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class AudioPlayerService {
  final AudioPlayer _player;

  AudioPlayerService._() : _player = AudioPlayer();

  static final AudioPlayerService _instance = AudioPlayerService._();

  factory AudioPlayerService() {
    return _instance;
  }

  Future<void> play(String url) async {
    try {
      await _player.stop();
      await _player.setUrl(url);
      await _player.play();
    } catch (e) {
      debugPrint('Error playing audio: $e');
    }
  }

  Future<void> pause() async {
    await _player.pause();
  }

  Future<void> resume() async {
    await _player.play();
  }

  Future<void> stop() async {
    await _player.stop();
  }

  Stream<Duration?> get positionStream => _player.positionStream;

  Stream<Duration?> get durationStream => _player.durationStream;

  Stream<PlayerState> get playerStateStream => _player.playerStateStream;

  Future<void> dispose() async {
    await _player.dispose();
  }

  Future<void> addPlayerCompleteListener(void Function() onComplete) async {
    _player.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        onComplete();
      }
    });
  }
}
