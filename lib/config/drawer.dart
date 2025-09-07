
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
              action: SystemAction(() => setNormalMode(context, globalConfig)),
            ),
            TextButtonDrawerModel(
              text: "Memorize Mode",
              showIcon: false,
              color: _getActiveColor<QuranMode>(globalConfig.quranMode, QuranMode.memorize),
              action: SystemAction(() => setMemorizeMode(context, globalConfig)),
            ),
            TextButtonDrawerModel(
              text: "Mushaf Mode",
              showIcon: false,
              consumer: globalConfig,
              color: _getActiveColor<QuranMode>(globalConfig.quranMode, QuranMode.mushaf),
              action: SystemAction(() => setMushafMode(context, globalConfig)),
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
        consumer: globalConfig,
        action: ExpandNestedDrawerAction([
          TextButtonDrawerModel(
            text: "On", 
            showIcon: false,
            color: _getActiveColor<bool>(globalConfig.isVoiceMode, true),
            action: SystemAction(() => turnOnVoiceMode(context, globalConfig))
          ),
          TextButtonDrawerModel(
            text: "Off", 
            showIcon: false,
            color: _getActiveColor<bool>(globalConfig.isVoiceMode, false),
            action: SystemAction(() => turnOffVoiceMode(context, globalConfig))
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
        color: Color(0xFFEA4335)
      ),
    ];
  }

  static Color _getActiveColor<T>(T activeOption, T activeValue) {
      return activeOption == activeValue ? Colors.grey : const Color(0xFF672CBC);
  }
}
