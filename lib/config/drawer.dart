
import 'package:flutter/material.dart';
import 'package:mtqmnuns/common/drawer_action.dart';
import 'package:mtqmnuns/components/drawer_text_button.dart';
import 'package:mtqmnuns/config/global.dart';
import 'package:provider/provider.dart';

class DrawerConfig {
  static List<TextButtonDrawerModel> getSettingDrawerTextButtonList(
    BuildContext context,
  ) {
    final globalConfig = context.watch<GlobalConfig>();

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
              color: _getActiveColor<QuranMode>(globalConfig.quranMode, QuranMode.normal),
              action: SystemAction(() => setNormalMode(globalConfig)),
            ),
            TextButtonDrawerModel(
              text: "Memorize Mode",
              showIcon: false,
              color: _getActiveColor<QuranMode>(globalConfig.quranMode, QuranMode.memorize),
              action: SystemAction(() => setMemorizeMode(globalConfig)),
            ),
            TextButtonDrawerModel(
              text: "Mushaf Mode",
              showIcon: false,
              consumer: globalConfig,
              color: _getActiveColor<QuranMode>(globalConfig.quranMode, QuranMode.mushaf),
              action: SystemAction(() => setMushafMode(globalConfig)),
            ),
          ]
        ),
      ),
    ];
  }

  static List<TextButtonDrawerModel> getMenuDrawerTextButtonList(
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
        action: ExpandNestedDrawerAction([
          TextButtonDrawerModel(
            text: "On", 
            showIcon: false,
            color: _getActiveColor<bool>(globalConfig.isVoiceMode, true),
            action: SystemAction(() => turnOnVoiceMode(globalConfig))
          ),
          TextButtonDrawerModel(
            text: "Off", 
            showIcon: false,
            color: _getActiveColor<bool>(globalConfig.isVoiceMode, false),
            action: SystemAction(() => turnOffVoiceMode(globalConfig))
          )
        ]),
      ),
      TextButtonDrawerModel(
        text: "Profile Setting",
        consumer: globalConfig,
        action: ExpandNestedDrawerAction([]),
      ),
      TextButtonDrawerModel(
        text: "Help & Support",
        consumer: globalConfig,
        action: ExpandNestedDrawerAction([]),
      ),
      TextButtonDrawerModel(
        text: "logout",
        consumer: globalConfig,
        action: ExpandNestedDrawerAction([]),
      ),
    ];
  }

  static Color _getActiveColor<T>(T activeOption, T activeValue) {
      return activeOption == activeValue ? Colors.grey : const Color(0xFF672CBC);
  }
}
