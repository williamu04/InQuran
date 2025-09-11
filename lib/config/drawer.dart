
import 'package:flutter/material.dart';
import 'package:mtqmnuns/components/drawer_text_button.dart';
import 'package:mtqmnuns/config/global.dart';
import 'package:provider/provider.dart';

class DrawerConfig {
  List<TextButtonDrawerModel> getSettingDrawerTextButtonList(
    BuildContext context,
  ) {
    final globalConfig = GlobalConfig();

    return [
      TextButtonDrawerModel(
        text: "Language",
        action: ExpandNestedDrawerAction([]),
      ),
      TextButtonDrawerModel(
        text: "General",
        action: ExpandNestedDrawerAction([]),
      ),
      TextButtonDrawerModel(
        text: "Quran Mode",
        consumer: globalConfig,
        action: ExpandNestedDrawerAction([
            TextButtonDrawerModel(
              text: "Normal Mode",
              showIcon: false,
              dynamicColor: () => _getQuranModeActiveColor(QuranMode.normal),
              action: SystemAction(() => globalConfig.setQuranMode(QuranMode.normal)),
            ),
            TextButtonDrawerModel(
              text: "Memorize Mode",
              showIcon: false,
              dynamicColor: () => _getQuranModeActiveColor(QuranMode.memorize),
              action: SystemAction(() => globalConfig.setQuranMode(QuranMode.memorize)),
            ),
            TextButtonDrawerModel(
              text: "Mushaf Mode",
              showIcon: false,
              dynamicColor: () => _getQuranModeActiveColor(QuranMode.mushaf),
              action: SystemAction(() => globalConfig.setQuranMode(QuranMode.mushaf)),
            ),
          ]
        ),
      ),
    ];
  }

  List<TextButtonDrawerModel> getMenuDrawerTextButtonList(
    BuildContext context,
  ) {
    final globalConfig = context.watch<GlobalConfig>();

    return [
      TextButtonDrawerModel(
        text: "Daily Task",
        action: ExpandNestedDrawerAction([]),
      ),
      TextButtonDrawerModel(
        text: "Voice Command Mode",
        consumer: globalConfig,
        action: ExpandNestedDrawerAction([
          TextButtonDrawerModel(
            text: "On", 
            showIcon: false,
            dynamicColor: () => _getVoiceActiveColor(true),
            action: SystemAction(() => globalConfig.setVoiceMode(true))
          ),
          TextButtonDrawerModel(
            text: "Off", 
            showIcon: false,
            dynamicColor: () => _getVoiceActiveColor(false),
            action: SystemAction(() => globalConfig.setVoiceMode(false))
          )
        ]),
      ),
      TextButtonDrawerModel(
        text: "Profile Setting",
        action: ExpandNestedDrawerAction([]),
      ),
      TextButtonDrawerModel(
        text: "Help & Support",
        action: ExpandNestedDrawerAction([]),
      ),
      TextButtonDrawerModel(
        text: "logout",
        action: SystemAction(()=> {}),
        showIcon: false,
        dynamicColor: () => Color(0xFFEA4335)
      ),
    ];
  }

  Color _getVoiceActiveColor(bool activeValue) {
      final globalConfig = GlobalConfig();
      return globalConfig.isVoiceMode == activeValue ? Colors.grey : const Color(0xFF672CBC);
  }
  Color _getQuranModeActiveColor(QuranMode activeValue) {
      final globalConfig = GlobalConfig();
      return globalConfig.quranMode == activeValue ? Colors.grey : const Color(0xFF672CBC);
  }
}
