import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:mtqmnuns/viewmodel/stt_viewmodel.dart';
import 'package:provider/provider.dart';

class TranscriptionText extends StatelessWidget {
  const TranscriptionText({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SttViewModel>(
      builder: (context, vm, _) {
        String displayText;

        if (vm.transcription.trim().isNotEmpty) {
          displayText = vm.transcription;
        } else if (vm.isListening) {
          displayText = "Listening...";
        } else {
          displayText = "Tap to Talk";
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: SizedBox(
            height: 30,
            child: AutoSizeText(
              displayText,
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
      },
    );
  }
}
