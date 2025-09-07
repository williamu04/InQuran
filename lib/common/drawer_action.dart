import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mtqmnuns/config/global.dart';
import 'package:mtqmnuns/routes/route.dart';

Future<void> setNormalMode(BuildContext context, GlobalConfig config) async {
  await config.setQuranMode(QuranMode.normal);
}

Future<void> setMemorizeMode(BuildContext context, GlobalConfig config) async {
  await config.setQuranMode(QuranMode.memorize);
}

Future<void> setMushafMode(BuildContext context, GlobalConfig config) async {
  await config.setQuranMode(QuranMode.mushaf);
}

Future<void> turnOnVoiceMode(BuildContext context, GlobalConfig config) async {
  await config.setVoiceMode(true);
  if (!context.mounted) return;
  final path = GoRouter.of(context).state.fullPath;
  if (path == AppRoutes.home.path) {
    context.go(AppRoutes.voice.path);
  }
}

Future<void> turnOffVoiceMode(BuildContext context, GlobalConfig config) async {
  await config.setVoiceMode(false);
  if (!context.mounted) return;
  final path = GoRouter.of(context).state.fullPath;
  if (path == AppRoutes.voice.path) {
    context.go(AppRoutes.home.path);
  }
}
