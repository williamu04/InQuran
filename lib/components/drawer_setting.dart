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
      title: 'Pengaturan',
      slideDirection: SlideDirection.right,
      createButtonList: _createSettingButtonList,
      getViewModel: (context) => context.read<SettingSlideDrawerViewModel>(),
    );
  }

  List<DisclosureButtonModel> _createSettingButtonList(
    GlobalConfig globalConfig,
  ) {
    return [
      DisclosureButtonModel.withDefaultTextStyle(
        text: "Bahasa",
        color: Color(0xFF994EF8),
        action: ExpandNestedDrawerAction([]),
      ),
      DisclosureButtonModel.withDefaultTextStyle(
        text: "Umum",
        color: Color(0xFF994EF8),
        action: ExpandNestedDrawerAction([]),
      ),
      DisclosureButtonModel.withDefaultTextStyle(
        text: "Mode Al-Qur'an",
        action: ExpandNestedDrawerAction([
          DisclosureButtonModel.withDefaultTextStyle(
            text: "Mode Normal",
            showIcon: false,
            fontWeight: FontWeight.w300,
            color:
                globalConfig.quranMode == QuranMode.normal
                    ? const Color(0xFF672CBC)
                    : Colors.grey,
            action: SystemAction(
              () => globalConfig.setQuranMode(QuranMode.normal),
            ),
          ),
          DisclosureButtonModel.withDefaultTextStyle(
            text: "Mode Hafalan",
            showIcon: false,
            fontWeight: FontWeight.w300,
            color:
                globalConfig.quranMode == QuranMode.memorize
                    ? const Color(0xFF672CBC)
                    : Colors.grey,
            action: SystemAction(
              () => globalConfig.setQuranMode(QuranMode.memorize),
            ),
          ),
          DisclosureButtonModel.withDefaultTextStyle(
            text: "Mode Mushaf",
            showIcon: false,
            fontWeight: FontWeight.w300,
            color:
                globalConfig.quranMode == QuranMode.mushaf
                    ? const Color(0xFF672CBC)
                    : Colors.grey,
            action: SystemAction(
              () => globalConfig.setQuranMode(QuranMode.mushaf),
            ),
          ),
        ]),
      ),
    ];
  }
}
