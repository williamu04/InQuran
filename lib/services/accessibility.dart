import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';

class AccessibilityService {
  Future<void> announce(BuildContext context, String message) async {
    if (message.isEmpty) return;
    try {
      final TextDirection direction = Directionality.of(context);
      await SemanticsService.announce(message, direction);
    } catch (_) {
      // No-op: announcing requires a mounted context and semantics enabled
    }
  }
}
