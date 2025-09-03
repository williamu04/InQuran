import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:mtqmnuns/common/navigation.dart';
import 'package:mtqmnuns/state/stt.dart';
import 'package:mtqmnuns/viewmodel/stt.dart';
import 'package:provider/provider.dart';

class TranscriptionText extends StatelessWidget {
  const TranscriptionText({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SttViewModel>(
      builder: (context, vm, _) {
        Widget child;

        switch (vm.state) {
          case SttIdle():
            child = _buildText("Tap to Talk");
            break;

          case SttListening(:var transcription):
            child = _buildText(transcription);
            break;

          case SttProcessing():
            child = const Center(
              child: CircularProgressIndicator(),
            );
            break;

          case SttSuccess(:var surah):
            WidgetsBinding.instance.addPostFrameCallback((_) {
              navigateToSurah(context, surah);
            });
            child = const SizedBox.shrink(); 
            break;

          case SttRetry(:var message):
            child = _buildText(message);
            break;

          case SttError(:var message):
            child = _buildText(message);
            break;
        }

        return child;
      },
    );
  }

  Widget _buildText(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: SizedBox(
        height: 30,
        child: AutoSizeText(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Color(0xFF672CBC),
            fontSize: 24,
            fontStyle: FontStyle.italic,
            fontFamily: "Plus Jakarta",
          ),
          maxLines: 3,
          minFontSize: 0,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
