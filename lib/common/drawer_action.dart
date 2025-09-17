import 'package:flutter/material.dart';
import 'package:mtqmnuns/config/global.dart';
import 'package:provider/provider.dart';

Future<void> setNormalMode(BuildContext context) async {
  final config = context.read<GlobalConfig>();
  await config.setQuranMode(QuranMode.normal);
}

Future<void> setMemorizeMode(BuildContext context) async {
  final config = context.read<GlobalConfig>();
  await config.setQuranMode(QuranMode.memorize);
}

Future<void> setMushafMode(BuildContext context) async {
  final config = context.read<GlobalConfig>();
  await config.setQuranMode(QuranMode.mushaf);
}

Future<void> turnOnVoiceMode(BuildContext context) async {
  final config = context.read<GlobalConfig>();
  await config.setVoiceMode(true);
}

Future<void> turnOffVoiceMode(BuildContext context) async {
  final config = context.read<GlobalConfig>();
  await config.setVoiceMode(false);
}
