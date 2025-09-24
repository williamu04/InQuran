import 'package:flutter/material.dart';
import 'package:mtqmnuns/common/top_bar_utils.dart';
import 'package:mtqmnuns/components/mic_button.dart';
import 'package:mtqmnuns/components/normal_button.dart';
import 'package:mtqmnuns/components/transcription_text.dart';

class VoiceHomeScreen extends StatelessWidget {
  final ValueNotifier<bool> isListening = ValueNotifier(false);

  VoiceHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final height = size.height;

    const scale = 0.92;

    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 20 * scale, horizontal: 24 * scale),
            child: TopBarUtility.buildPurpleTitleTopbar(context: context, title: "InQuran"),
          ),
          _title(height, scale),
          SizedBox(height: height * 0.055 * scale),
          MicButton(size: height * 0.3 * scale),
          SizedBox(height: height * 0.035 * scale),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TranscriptionText(idleText: 'Tap To Talk'),
              SizedBox(height: height * 0.008 * scale),
              _helpingText(height, scale),
            ],
          ),
          SizedBox(height: height * 0.03 * scale),
          NormalButton(),
        ],
      ),
    );
  }

  Widget _helpingText(double height, double scale) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: height * 0.25 * scale),
      child: Text(
        "Membantu mereka yang memiliki gangguan penglihatan untuk menekan tombol.",
        textAlign: TextAlign.center,
        style: TextStyle(
          color: const Color(0xFF7C8BA0),
          fontSize: height * 0.013 * scale,
          fontFamily: "Plus Jakarta",
        ),
      ),
    );
  }

  Widget _title(double height, double scale) {
    return Column(
      children: [
        Text(
          "Mode",
          style: TextStyle(
            fontFamily: "Plus Jakarta",
            fontSize: height * 0.035 * scale,
            color: const Color(0xFF672CBC),
          ),
        ),
        Text(
          "Voice",
          style: TextStyle(
            fontFamily: "Plus Jakarta",
            fontSize: height * 0.035 * scale,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF672CBC),
            height: 1.0,
          ),
        ),
        Text(
          "Command",
          style: TextStyle(
            fontFamily: "Plus Jakarta",
            fontSize: height * 0.035 * scale,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF672CBC),
            height: 1.0,
          ),
        ),
      ],
    );
  }
}