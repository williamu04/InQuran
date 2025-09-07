import 'package:mtqmnuns/config/global.dart';

Future<void> setNormalMode(GlobalConfig config) async {
  await config.setQuranMode(QuranMode.normal);
}

Future<void> setMemorizeMode(GlobalConfig config) async {
  await config.setQuranMode(QuranMode.memorize);
}

Future<void> setMushafMode(GlobalConfig config) async {
  await config.setQuranMode(QuranMode.mushaf);
}

Future<void> turnOnVoiceMode(GlobalConfig config) async {
  await config.setVoiceMode(true);
}

Future<void> turnOffVoiceMode(GlobalConfig config) async {
  await config.setVoiceMode(false);
}
