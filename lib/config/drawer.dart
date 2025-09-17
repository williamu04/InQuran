
import 'package:flutter/material.dart';
import 'package:mtqmnuns/config/global.dart';
import 'package:mtqmnuns/models/disclosure_button.dart';
import 'package:mtqmnuns/state/disclosure_button.dart';
import 'package:provider/provider.dart';

class DrawerConfig {
  List<DisclosureButtonModel> getProfileDrawer() {
    return [
      DisclosureButtonModel(
        text: "Notes",
        showIcon: false,
        action: SystemAction(() => {}),
      ),
      DisclosureButtonModel(
        text: "Favourite",
        showIcon: false,
        action: SystemAction(() => {}),
      ),
      DisclosureButtonModel(
        text: "Points",
        showIcon: false,
        action: SystemAction(() => {}),
      ),
      DisclosureButtonModel(
        text: "Help & Support",
        showIcon: false,
        action: SystemAction(() => {}),
      ),
      DisclosureButtonModel(
        text: "logout",
        action: SystemAction(()=> {}),
        showIcon: false,
        color: Color(0xFFEA4335)
      ),
    ];
  }

  List<DisclosureButtonModel> getMenuDrawerTextButtonList(
    BuildContext context,
  ) {
    final globalConfig = context.watch<GlobalConfig>();

    return [
      DisclosureButtonModel(
        text: "Daily Task",
        action: ExpandNestedDrawerAction([]),
      ),
      DisclosureButtonModel(
        text: "Voice Command Mode",
        action: ExpandNestedDrawerAction([
          DisclosureButtonModel(
            text: "On", 
            showIcon: false,
            color: _getVoiceActiveColor(true),
            action: SystemAction(() => globalConfig.setVoiceMode(true))
          ),
          DisclosureButtonModel(
            text: "Off", 
            showIcon: false,
            color: _getVoiceActiveColor(false),
            action: SystemAction(() => globalConfig.setVoiceMode(false))
          )
        ]),
      ),
      DisclosureButtonModel(
        text: "Profile Setting",
        action: ExpandNestedDrawerAction([]),
      ),
      DisclosureButtonModel(
        text: "Help & Support",
        action: ExpandNestedDrawerAction([]),
      ),
      DisclosureButtonModel(
        text: "logout",
        action: SystemAction(()=> {}),
        showIcon: false,
        color: Color(0xFFEA4335)
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
