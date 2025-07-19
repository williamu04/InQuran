import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:go_router/go_router.dart';
import 'package:mtqmnuns/components/mic_button.dart';
import 'package:mtqmnuns/data/local/db/app_database.dart';
import 'package:mtqmnuns/routes/route.dart';
import 'package:mtqmnuns/services/stt_service.dart';
import 'package:mtqmnuns/viewmodel/book_viewmodel.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class HomeDisabilityScreen extends StatefulWidget {
  @override
  State<HomeDisabilityScreen> createState() => _HomeDisabilityScreenState();
}

class _HomeDisabilityScreenState extends State<HomeDisabilityScreen> {
  final ValueNotifier<bool> isListening = ValueNotifier(false);
  final ValueNotifier<String> transcript = ValueNotifier('');
  late final SttService stt;

  @override
  void initState() {
    super.initState();
    stt = Provider.of<SttService>(context, listen: false);
    stt.onTranscriptHandled = processTranscript;
  }

  Future<bool> processTranscript(String transcriptStream) async {
    final bookViewModel = Provider.of<BookViewModel>(context, listen: false);
    final SurahData? match = await bookViewModel.fuzzyFindSurahFromText(transcriptStream);

    if (match != null) {
      debugPrint('Matched Surah: ${match.nameLatin}');
      if (!mounted) return false;
      context.push(Uri(
        path: AppRoutes.surah.path,
        queryParameters: {
          'id': '${match.id}',
          'ayah': '1',
        },
      ).toString());
      transcript.value = '';
      isListening.value = false;
      return Future.value(true); 
    }


    debugPrint('No matched Surah');
    return Future.value(false); 
  }

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
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 115),
      child: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(), 
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 15),
              _title(),
              const SizedBox(height: 60),
              MicButton(
                size: 200,
                isListening: isListening,
                onPressed: () => _handleMicPressed(context),
              ),
              const SizedBox(height: 60),
              _instructionText(context),
            ],
          ),
        ),
      ),
    );
  }


  Widget _instructionText(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: isListening,
      builder: (context, listening, _) {
        return Center(
          child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _mainInstructionText(listening, context),
                const SizedBox(height: 8),
                ConstrainedBox( 
                  constraints: BoxConstraints(maxWidth: 250),
                child: Text(
                  "Help those who are visually impaired to press the button",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF7C8BA0),
                    fontSize: 12,
                    fontFamily: "Plus Jakarta",
                  ),
                ),
                )
              ],
            ),
          );
      },
    );
  }


  Widget _mainInstructionText(bool listening, BuildContext context) {
    return ValueListenableBuilder<String>(
        valueListenable: transcript,
        builder: (context, transcriptText, _) {
        String displayText;

        if (transcriptText.trim().isNotEmpty) {
          displayText = transcriptText;
        } else if (isListening.value) {
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


  Widget _title() {
    return Column(
      children: [
        Text(
          "Voice",
          style: TextStyle(
            fontFamily: "Plus Jakarta",
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Color(0xFF672CBC),
            height: 1.0,
          ),
        ),
        Text(
          "Command",
          style: TextStyle(
            fontFamily: "Plus Jakarta",
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Color(0xFF672CBC),
            height: 1.0,
          ),
        ),
        Text(
          "Mode",
          style: TextStyle(
            fontFamily: "Plus Jakarta",
            fontSize: 32,
            color: Color(0xFF672CBC),
          ),
        ),
      ],
    );
  }

  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> _micPermissionErrorMessage() {
    return ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Microphone permission is required.'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

}
