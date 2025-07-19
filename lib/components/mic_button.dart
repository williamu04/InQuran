import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class MicButton extends StatelessWidget {
  final double size;
  final ValueListenable<bool> isListening;
  final void Function() onPressed;

  const MicButton({
    super.key,
    required this.size,
    required this.isListening,
    required this.onPressed
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: isListening,
      builder: (context, listening, _) {
        return GestureDetector(
          onTap: onPressed, 
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey.shade300, width: 2),
              boxShadow: [
                BoxShadow(
                  color: Color(0xFF672CBC).withOpacity(0.3),
                  blurRadius: 28,
                  spreadRadius: 7,
                ),
              ],
            ),
            child: Center(
              child: Icon(
                listening ? LucideIcons.audioLines : LucideIcons.power,
                color: Color(0xFF672CBC),
                size: size * 0.675,
              ),
            ),
          ),
        );
      },
    );
  }
}
