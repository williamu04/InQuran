import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:mtqmnuns/config/global.dart';

class NormalButton extends StatelessWidget {
  final GlobalConfig globalConfig;
  final double size;

  const NormalButton({super.key, this.size = 60, required this.globalConfig});

  @override
  Widget build(BuildContext context) {
    final Color color = const Color(0xFF672CBC);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Semantics(
          button: true,
          label: 'Kembali ke mode normal',
          hint: 'Ketuk dua kali untuk menonaktifkan mode suara',
          child: Tooltip(
            message: 'Kembali ke mode normal',
            child: GestureDetector(
              onTap: () {
                globalConfig.setVoiceMode(false);
              },
              child: Container(
                height: size,
                width: size,
                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
                alignment: Alignment.center,
                child: Icon(
                  LucideIcons.house,
                  color: Colors.white,
                  size: size * 0.6,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 6),
        Semantics(
          label: 'Kembali ke mode normal',
          child: SizedBox(
            width: size * 1.2,
            child: AutoSizeText(
              "Back to Normal Mode",
              maxLines: 2,
              textAlign: TextAlign.center,
              style: TextStyle(color: color, fontWeight: FontWeight.w600),
              minFontSize: 1,
            ),
          ),
        ),
      ],
    );
  }
}
