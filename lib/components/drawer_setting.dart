
import 'package:flutter/material.dart';
import 'package:mtqmnuns/components/drawer_generic_helper.dart';
import 'package:mtqmnuns/config/global.dart';
import 'package:mtqmnuns/models/disclosure_button.dart';
import 'package:mtqmnuns/state/disclosure_button.dart';
import 'package:mtqmnuns/viewmodel/drawer.dart';
import 'package:provider/provider.dart';

class SettingDrawer extends StatelessWidget {
  const SettingDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return GenericDrawer<SettingSlideDrawerViewModel>(
      title: 'Settings',
      slideDirection: SlideDirection.right,
      createButtonList: _createSettingButtonList,
      getViewModel: (context) => context.read<SettingSlideDrawerViewModel>(),
    );
  }

  List<DisclosureButtonModel> _createSettingButtonList(GlobalConfig globalConfig) {
    return [
      DisclosureButtonModel(
        text: "Language",
        action: ExpandNestedDrawerAction([]),
      ),
      DisclosureButtonModel(
        text: "General",
        action: ExpandNestedDrawerAction([]),
      ),
      DisclosureButtonModel(
        text: "Quran Mode",
        action: ExpandNestedDrawerAction([
          DisclosureButtonModel(
            text: "Normal Mode",
            showIcon: false,
            color: globalConfig.quranMode == QuranMode.normal ? const Color(0xFF672CBC) : Colors.grey,
            action: SystemAction(() => globalConfig.setQuranMode(QuranMode.normal)),
          ),
          DisclosureButtonModel(
            text: "Memorize Mode",
            showIcon: false,
            color: globalConfig.quranMode == QuranMode.memorize ? const Color(0xFF672CBC) : Colors.grey,
            action: SystemAction(() => globalConfig.setQuranMode(QuranMode.memorize)),
          ),
          DisclosureButtonModel(
            text: "Mushaf Mode",
            showIcon: false,
            color: globalConfig.quranMode == QuranMode.mushaf ? const Color(0xFF672CBC) : Colors.grey,
            action: SystemAction(() => globalConfig.setQuranMode(QuranMode.mushaf)),
          ),
        ])
      )
    ];
  }
}