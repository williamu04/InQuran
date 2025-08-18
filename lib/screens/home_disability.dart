import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mtqmnuns/components/mic_button.dart';
import 'package:mtqmnuns/components/transcription_text.dart';
import 'package:mtqmnuns/routes/route.dart';
import 'package:mtqmnuns/viewmodel/stt_viewmodel.dart';
import 'package:provider/provider.dart';

class HomeDisabilityScreen extends StatefulWidget {
  @override
  State<HomeDisabilityScreen> createState() => _HomeDisabilityScreenState();
}

class _HomeDisabilityScreenState extends State<HomeDisabilityScreen> {
  final ValueNotifier<bool> isListening = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    return Consumer<SttViewModel>(
      builder: (context, vm, _) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (vm.foundSurah != null) {
            context.push(
              Uri(
                path: AppRoutes.surah.path,
                queryParameters: {
                  'id': '${vm.foundSurah!.id}',
                  'ayah': '1',
                },
              ).toString(),
            );
            vm.stopListening(); 
          }
        });

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

                  MicButton(size: 200),

                  const SizedBox(height: 60),

                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      TranscriptionText(),
                      const SizedBox(height: 8),
                      _helpingText(),
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }


  Widget _helpingText() {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 250),
      child: const Text(
        "Help those who are visually impaired to press the button",
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Color(0xFF7C8BA0),
          fontSize: 12,
          fontFamily: "Plus Jakarta",
        ),
      )
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
}
