import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:inquran/common/snackbar.dart';
import 'package:inquran/state/stt.dart';
import 'package:inquran/viewmodel/stt.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:inquran/common/app_color.dart';

class MicButton extends StatelessWidget {
  final double size;

  const MicButton({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    return Consumer<SttViewModel>(
      builder: (context, vm, _) {
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
                  color: AppColors.primary.withValues(alpha: 0.3),
                  blurRadius: 25,
                  spreadRadius: 4,
                ),
              ],
            ),
            child: Center(
              child: Icon(
                isListening ? LucideIcons.audioLines : LucideIcons.power,
                color: AppColors.primary,
                size: size * 0.675,
              ),
            ),
          ),
        );
      },
    );
  }

  void handleMicPressed(BuildContext context, SttViewModel vm) async {
    void showError() => showErrorPopup(context, 'microphone permission are needed');

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
