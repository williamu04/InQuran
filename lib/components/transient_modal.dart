import 'dart:async';
import 'package:flutter/material.dart';

class TransientMessageModal extends StatefulWidget {
  final String text;
  final Duration duration;
  final Duration fadeDuration;

  const TransientMessageModal({
    super.key,
    required this.text,
    this.duration = const Duration(seconds: 2),
    this.fadeDuration = const Duration(milliseconds: 400),
  });

  @override
  State<TransientMessageModal> createState() => _TransientMessageModalState();

  static void show(
    BuildContext context, {
    required String text,
    Duration duration = const Duration(seconds: 2),
    Duration fadeDuration = const Duration(milliseconds: 400),
  }) {
    final overlay = Overlay.of(context);

    final overlayEntry = OverlayEntry(
      builder:
          (_) => TransientMessageModal(
            text: text,
            duration: duration,
            fadeDuration: fadeDuration,
          ),
    );

    overlay.insert(overlayEntry);
    final total = fadeDuration + duration + fadeDuration;

    Future.delayed(total, () {
      overlayEntry.remove();
    });
  }
}

class _TransientMessageModalState extends State<TransientMessageModal>
    with SingleTickerProviderStateMixin {
  double _opacity = 0.0;

  @override
  void initState() {
    super.initState();

    // Fade in
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() => _opacity = 1.0);

      Future.delayed(widget.duration + widget.fadeDuration, () {
        if (mounted) setState(() => _opacity = 0.0);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: IgnorePointer(child: Container(color: Colors.transparent)),
        ),
        Center(
          child: AnimatedOpacity(
            opacity: _opacity,
            duration: widget.fadeDuration,
            child: Container(
              constraints: const BoxConstraints(maxWidth: 250, minWidth: 160),
              margin: const EdgeInsets.symmetric(horizontal: 24),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.9),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.black.withValues(alpha: 0.3),
                  width: 0.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Text(
                widget.text,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  decoration: TextDecoration.none,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
