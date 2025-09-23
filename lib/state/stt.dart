import 'package:flutter/cupertino.dart';

sealed class SttState {}

class SttIdle extends SttState {}

class SttNetworkError extends SttState {}

class SttListening extends SttState {
  final Stream<String> transcriptionStream;
  SttListening(this.transcriptionStream);
}

class SttSuccess extends SttState {
  final void Function(BuildContext) action;
  SttSuccess(this.action);
}

class SttRetry extends SttState {}

class SttProcessing extends SttState {
  final String finalTranscription;
  SttProcessing(this.finalTranscription);
}
