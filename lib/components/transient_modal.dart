import 'dart:async';
import 'package:flutter/material.dart';

class TransientMessageService extends ChangeNotifier {
  OverlayEntry? _currentOverlay;

  void showMessage(BuildContext context, String text,
      {Duration duration = const Duration(seconds: 2),
      Duration fadeDuration = const Duration(milliseconds: 400)}) {
    // Remove previous overlay if exists
    _currentOverlay?.remove();

    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (_) => _TransientMessageWidget(
        text: text,
        duration: duration,
        fadeDuration: fadeDuration,
        onDismissed: () => _currentOverlay = null,
      ),
    );

    _currentOverlay = overlayEntry;
    overlay.insert(overlayEntry);
  }
}


class _TransientMessageWidget extends StatefulWidget {
  final String text;
  final Duration duration;
  final Duration fadeDuration;
  final VoidCallback onDismissed;

  const _TransientMessageWidget({
    required this.text,
    required this.duration,
    required this.fadeDuration,
    required this.onDismissed,
  });

  @override
  State<_TransientMessageWidget> createState() => _TransientMessageWidgetState();
}

class _TransientMessageWidgetState extends State<_TransientMessageWidget>
    with SingleTickerProviderStateMixin {
  double _opacity = 0.0;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() => _opacity = 1.0);

      Future.delayed(widget.duration + widget.fadeDuration, () {
        if (mounted) {
          setState(() => _opacity = 0.0);

          Future.delayed(widget.fadeDuration, () {
            widget.onDismissed();
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(child: IgnorePointer(child: Container(color: Colors.transparent))),
        Center(
          child: AnimatedOpacity(
            opacity: _opacity,
            duration: widget.fadeDuration,
            child: Container(
              constraints: const BoxConstraints(maxWidth: 250, minWidth: 160),
              margin: const EdgeInsets.symmetric(horizontal: 24),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.black.withOpacity(0.3), width: 0.5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
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
