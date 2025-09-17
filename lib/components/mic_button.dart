import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:mtqmnuns/components/error_popup.dart';
import 'package:mtqmnuns/state/stt.dart';
import 'package:mtqmnuns/viewmodel/stt.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class MicButton extends StatelessWidget {
  final double size;

  const MicButton({
    super.key,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<SttViewModel>(
      builder: (context, vm, _) {
        // Determine whether we are listening based on the state
        final isListening = switch (vm.state) {
          SttListening() => true,
          SttIdle() => false,
          SttSuccess() => false,
          SttRetry() => true,
          SttProcessing() => true,
          SttNetworkError() => false,
        };

        return GestureDetector(
          onTap: () => handleMicPressed(context, vm),
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey.shade300, width: 2),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF672CBC).withOpacity(0.3),
                  blurRadius: 28,
                  spreadRadius: 7,
                ),
              ],
            ),
            child: Center(
              child: Icon(
                isListening ? LucideIcons.audioLines : LucideIcons.power,
                color: const Color(0xFF672CBC),
                size: size * 0.675,
              ),
            ),
          ),
        );
      },
    );
  }

  void handleMicPressed(BuildContext context, SttViewModel vm) async {
    void showError() => errorPopup(context, 'microphone permission are needed');

    var status = await Permission.microphone.status;
    if (status.isDenied) status = await Permission.microphone.request();
    if (status.isPermanentlyDenied) openAppSettings();

    if (status.isGranted) {
      vm.toggleListening(); 
    } else {
      showError();
    }
  }
}
