import 'dart:async';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class AudioPlayerService {
  final AudioPlayer _player = AudioPlayer();

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

  StreamSubscription<PlayerState>? _completeSub;

  Future<void> addPlayerCompleteListener(void Function() onComplete) async {
    await _completeSub?.cancel(); // pastikan tidak double

    _completeSub = _player.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        onComplete();
      }
    });
  }

  Future<void> dispose() async {
    await _completeSub?.cancel();
    await _player.dispose();
  }

  /// Listener untuk perubahan status play/pause
  Future<void> addPlayerStateListener(
    void Function(bool isPlaying) onStateChanged,
  ) async {
    _player.playerStateStream.listen((state) {
      onStateChanged(state.playing);
    });
  }
}
