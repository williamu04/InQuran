import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:inquran/common/snackbar.dart';
import 'package:inquran/state/stt.dart';
import 'package:inquran/viewmodel/stt.dart';
import 'package:provider/provider.dart';
import 'package:inquran/common/app_color.dart';

sealed class TextSource {}
class StaticText extends TextSource { final String text; StaticText(this.text); }
class StreamText extends TextSource { final Stream<String> stream; StreamText(this.stream); }

class TranscriptionText extends StatelessWidget {
  final String idleText;
  const TranscriptionText({
    super.key, required this.idleText
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<SttViewModel>(
      builder: (context, vm, _) {
        Widget child;

        switch (vm.state) {
          case SttIdle():
            child = _buildText(StaticText(idleText));
            break;

          case SttListening(:var transcriptionStream):
            child = _buildText(StreamText(transcriptionStream));
            break;

          case SttSuccess(:var action):
            child = _buildText(StaticText("Perintah Ditemukan")); 
            WidgetsBinding.instance.addPostFrameCallback((_) {
              action(context);
              vm.changeStateToIdle();
            });
            break;

          case SttRetry():
            child = _buildText(StaticText('Perintah Tidak Dikenali'));
            break;

          case SttProcessing(: var finalTranscription):
            child = _buildText(StaticText(finalTranscription));
            break;
          case SttNetworkError():
            child = _buildText(StaticText("Ketuk untuk Berbicara"));
            WidgetsBinding.instance.addPostFrameCallback((_) {
                showErrorPopup(context, 'Tidak ada koneksi internet. Sambungkan internet untuk menggunakan fitur ini');
                vm.changeStateToIdle();
              });
            vm.changeStateToIdle();
            break;
        }

        return child;
      },
    );
  }

  Widget _buildText(TextSource source) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: SizedBox(
        height: 30,
        child: switch (source) {
          StaticText(:final text) => _styledText(text),
          StreamText(:final stream) => StreamBuilder<String>(
              stream: stream,
              builder: (context, snapshot) {
                return _styledText(snapshot.data ?? "Mendengarkan...");
              },
            ),
        },
      ),
    );
  }

  Widget _styledText(String text) {
    return AutoSizeText(
      text,
      textAlign: TextAlign.center,
      style: const TextStyle(
        color: AppColors.primary,
        fontSize: 24,
        fontStyle: FontStyle.italic,
        fontFamily: "Plus Jakarta",
      ),
      maxLines: 3,
      minFontSize: 0,
      overflow: TextOverflow.ellipsis,
    );
  }

}
