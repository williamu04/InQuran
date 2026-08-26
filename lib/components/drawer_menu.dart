import 'package:flutter/material.dart';
import 'package:inquran/components/drawer_generic_helper.dart';
import 'package:inquran/config/global.dart';
import 'package:inquran/state/disclosure_button.dart';
import 'package:inquran/state/ui_controllers.dart';
import 'package:provider/provider.dart';
import 'package:inquran/common/app_color.dart';

class MenuDrawer extends StatelessWidget {
  const MenuDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return GenericDrawer<MenuSlideDrawer>(
      title: 'InQuran',
      slideDirection: SlideDirection.left,
      createButtonList: _createMenuButtonList,
      getViewModel: (context) => context.read<MenuSlideDrawer>(),
    );
  }

  List<DisclosureButtonModel> _createMenuButtonList(BuildContext context) {
    GlobalConfig globalConfig = context.read<GlobalConfig>();
    return [
      DisclosureButtonModel.withDefaultTextStyle(
        text: "Tugas Harian",
        action: ExpandNestedDrawerAction([]),
      ),
      DisclosureButtonModel.withDefaultTextStyle(
        text: "Mode Voice Command",
        action: ExpandNestedDrawerAction([
          DisclosureButtonModel.withDefaultTextStyle(
            text: "AKTIF",
            showIcon: false,
            fontWeight: FontWeight.w300,
            color:
                globalConfig.isVoiceMode == true
                    ? AppColors.primary
                    : Colors.grey,
            action: SystemAction(() => globalConfig.setVoiceMode(true)),
          ),
          DisclosureButtonModel.withDefaultTextStyle(
            text: "NONAKTIF",
            fontWeight: FontWeight.w300,
            showIcon: false,
            color:
                globalConfig.isVoiceMode == false
                    ? AppColors.primary
                    : Colors.grey,
            action: SystemAction(() => globalConfig.setVoiceMode(false)),
          ),
        ]),
      ),
      DisclosureButtonModel.withDefaultTextStyle(
        text: "Bantuan & Dukungan",
        action: ExpandNestedDrawerAction([]),
      ),
    ];
  }
}