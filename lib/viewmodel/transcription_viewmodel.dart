import 'package:flutter/material.dart';
import 'package:mtqmnuns/services/stt_service.dart';
import 'package:permission_handler/permission_handler.dart';

class TranscriptionViewModel extends ChangeNotifier {
  final SttService stt;
  final ValueNotifier<bool> isListening = ValueNotifier(false);
  final ValueNotifier<String> transcript = ValueNotifier('');

  TranscriptionViewModel(this.stt);


  void _handleMicPressed(BuildContext context) async {
    if (!isListening.value) {
      var status = await Permission.microphone.status;
      if (status.isDenied) status = await Permission.microphone.request();
      if (status.isPermanentlyDenied) openAppSettings();
      if (!mounted) return;

      if (status.isGranted) {
        stt.startListening();
        stt.transcriptionStream.listen((text) {
          if (text.trim().isNotEmpty) {
            transcript.value = text.trim();
          }
        });

        isListening.value = true;
      } else {
        _micPermissionErrorMessage();
      }
    } else {
      stt.stopListening();
      transcript.value = ''; 
      isListening.value = false;
    }
  }

  @override
  void dispose() {
    stt.dispose();
    super.dispose();
  }
}
