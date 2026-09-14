import 'package:flutter/material.dart';
import 'package:inquran/components/top_bar_utils.dart';
import 'package:inquran/components/mic_button.dart';
import 'package:inquran/components/normal_button.dart';
import 'package:inquran/components/transcription_text.dart';
import 'package:inquran/common/app_color.dart';

class VoiceHomeScreen extends StatelessWidget {
  final ValueNotifier<bool> isListening = ValueNotifier(false);

  VoiceHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final height = size.height;
    const scale = 0.92;

    return Scaffold(
      body: SafeArea(
        child: Semantics(
          namesRoute: true,
          label: 'Mode Voice Command',
          child: SingleChildScrollView(
            child: SizedBox(
              width: double.infinity,
              child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 🔹 Topbar
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 12 * scale,
                    horizontal: 16 * scale,
                  ),
                  child: TopBarUtility.buildPurpleTitleTopbar(
                    context: context,
                    title: "InQuran",
                  ),
                ),

                // 🔹 Title Section
                _TitleSection(height: height, scale: scale),

                SizedBox(height: height * 0.055 * scale),

                // 🔹 Mic Button (self-labeled for TalkBack)
                MicButton(size: height * 0.3 * scale),

                SizedBox(height: height * 0.035 * scale),

                // 🔹 Transcription Text (live region, announces itself)
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TranscriptionText(idleText: 'Tap To Talk'),
                    SizedBox(height: height * 0.008 * scale),
                    _HelpingText(height: height, scale: scale),
                  ],
                ),

                SizedBox(height: height * 0.03 * scale),

                // 🔹 Normal Button (self-labeled for TalkBack)
                NormalButton(),
              ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Bagian judul
class _TitleSection extends StatelessWidget {
  final double height;
  final double scale;

  const _TitleSection({required this.height, required this.scale});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      header: true,
      label: "Mode Voice Command",
      child: Column(
        children: [
          Text(
            "Mode",
            style: TextStyle(
              fontFamily: "Plus Jakarta",
              fontSize: height * 0.035 * scale,
              color: AppColors.primary,
            ),
          ),
          Text(
            "Voice",
            style: TextStyle(
              fontFamily: "Plus Jakarta",
              fontSize: height * 0.035 * scale,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
              height: 1.0,
            ),
          ),
          Text(
            "Command",
            style: TextStyle(
              fontFamily: "Plus Jakarta",
              fontSize: height * 0.035 * scale,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
              height: 1.0,
            ),
          ),
        ],
      ),
    );
  }
}

/// Teks bantuan
class _HelpingText extends StatelessWidget {
  final double height;
  final double scale;

  const _HelpingText({required this.height, required this.scale});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: height * 0.25 * scale),
      child: Semantics(
        label:
            "Teks bantuan. Membantu mereka yang memiliki gangguan penglihatan untuk menekan tombol. Ucapkan bantuan untuk mendengar daftar perintah.",
        child: Text(
          "Membantu mereka yang memiliki gangguan penglihatan untuk menekan tombol.",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: height * 0.013 * scale,
            fontFamily: "Plus Jakarta",
          ),
        ),
      ),
    );
  }
}
