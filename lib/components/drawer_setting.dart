import 'package:flutter/material.dart';
import 'package:inquran/components/drawer_generic_helper.dart';
import 'package:inquran/config/global.dart';
import 'package:inquran/state/disclosure_button.dart';
import 'package:inquran/state/ui_controllers.dart';
import 'package:provider/provider.dart';
import 'package:inquran/common/app_color.dart';

class SettingDrawer extends StatelessWidget {
  const SettingDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return GenericDrawer<SettingSlideDrawer>(
      title: 'Pengaturan',
      slideDirection: SlideDirection.right,
      createButtonList: _createSettingButtonList,
      getViewModel: (context) => context.read<SettingSlideDrawer>(),
    );
  }

  List<DisclosureButtonModel> _createSettingButtonList(
    BuildContext context,
  ) {
    GlobalConfig globalConfig = context.read<GlobalConfig>();
    return [
      DisclosureButtonModel.withDefaultTextStyle(
        text: "Bahasa",
        color: AppColors.primaryLight,
        action: ExpandNestedDrawerAction([]),
      ),
      DisclosureButtonModel.withDefaultTextStyle(
        text: "Umum",
        color: AppColors.primaryLight,
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
                    ? AppColors.primary
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
                    ? AppColors.primary
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
                    ? AppColors.primary
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
