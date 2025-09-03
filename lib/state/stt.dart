import 'package:mtqmnuns/dto/surah.dart';

sealed class SttState {}

class SttIdle extends SttState {}

class SttListening extends SttState {
  final String transcription;
  SttListening(this.transcription);
}

class SttProcessing extends SttState {
  final String transcription;
  SttProcessing(this.transcription);
}

class SttSuccess extends SttState {
  final SurahInfoDto surah;
  SttSuccess(this.surah);
}

class SttRetry extends SttState {
  final String message;
  SttRetry(this.message);
}

class SttError extends SttState {
  final String message;
  SttError(this.message);
}
