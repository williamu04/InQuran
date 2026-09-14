import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';

/// Announces [message] through the screen reader (TalkBack/VoiceOver).
///
/// Uses the first platform view so it also works from code without a
/// [BuildContext] (view-models). For a single-window mobile app this is the
/// app's only view.
void announceToScreenReader(String message) {
  final view = WidgetsBinding.instance.platformDispatcher.views.firstOrNull;
  if (view == null) return;
  SemanticsService.sendAnnouncement(view, message, TextDirection.ltr);
}
