import 'package:flutter/material.dart';
import 'package:mtqmnuns/components/mic_button.dart';
import 'package:mtqmnuns/components/normal_button.dart';
import 'package:mtqmnuns/components/transcription_text.dart';
import 'package:mtqmnuns/config/global.dart';

class VoiceScreen extends StatefulWidget {
  @override
  State<VoiceScreen> createState() => _VoiceScreenState();
}

class _VoiceScreenState extends State<VoiceScreen> {
  final ValueNotifier<bool> isListening = ValueNotifier(false);
  final globalConfig = GlobalConfig();
  @override
  void initState() {
    super.initState();
    _setup();
  }
  Future<void> _setup() async {
    globalConfig.setVoiceMode(true);
    setState(() {}); 
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final height = size.height;

    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _title(height),
          SizedBox(height: height * 0.055),
          MicButton(size: height * 0.3),
          SizedBox(height: height * 0.035),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TranscriptionText(),
              SizedBox(height: height * 0.008),
              _helpingText(height),
            ],
          ),
          SizedBox(height: height * 0.03),
          NormalButton(globalConfig: globalConfig),
        ],
      ),
    );
  }

  Widget _helpingText(double height) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: height * 0.25),
      child: Text(
        "Help those who are visually impaired to press the button",
        textAlign: TextAlign.center,
        style: TextStyle(
          color: const Color(0xFF7C8BA0),
          fontSize: height * 0.013,
          fontFamily: "Plus Jakarta",
        ),
      ),
    );
  }

  Widget _title(double height) {
    return Column(
      children: [
        Text(
          "Voice",
          style: TextStyle(
            fontFamily: "Plus Jakarta",
            fontSize: height * 0.035,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF672CBC),
            height: 1.0,
          ),
        ),
        Text(
          "Command",
          style: TextStyle(
            fontFamily: "Plus Jakarta",
            fontSize: height * 0.035,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF672CBC),
            height: 1.0,
          ),
        ),
        Text(
          "Mode",
          style: TextStyle(
            fontFamily: "Plus Jakarta",
            fontSize: height * 0.035,
            color: const Color(0xFF672CBC),
          ),
        ),
      ],
    );
  }
}
