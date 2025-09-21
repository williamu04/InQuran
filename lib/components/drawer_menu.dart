import 'package:flutter/material.dart';
import 'package:mtqmnuns/components/drawer_generic_helper.dart';
import 'package:mtqmnuns/config/global.dart';
import 'package:mtqmnuns/models/disclosure_button.dart';
import 'package:mtqmnuns/routes/route.dart';
import 'package:mtqmnuns/state/disclosure_button.dart';
import 'package:mtqmnuns/viewmodel/drawer.dart';
import 'package:provider/provider.dart';

class MenuDrawer extends StatelessWidget {
  const MenuDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return GenericDrawer<MenuSlideDrawerViewModel>(
      title: 'InQuran',
      slideDirection: SlideDirection.left,
      createButtonList: _createMenuButtonList,
      getViewModel: (context) => context.read<MenuSlideDrawerViewModel>(),
    );
  }

  List<DisclosureButtonModel> _createMenuButtonList(GlobalConfig globalConfig) {
    return [
      DisclosureButtonModel.withDefaultTextStyle(
        text: "Daily Task",
        action: ExpandNestedDrawerAction([]),
      ),
      DisclosureButtonModel.withDefaultTextStyle(
        text: "Voice Command Mode",
        action: ExpandNestedDrawerAction([
          DisclosureButtonModel.withDefaultTextStyle(
            text: "ON",
            showIcon: false,
            fontWeight: FontWeight.w300,
            color: globalConfig.isVoiceMode == true ? const Color(0xFF672CBC) : Colors.grey,
            action: SystemAction(() => globalConfig.setVoiceMode(true))
          ),
          DisclosureButtonModel.withDefaultTextStyle(
            text: "OFF",
            fontWeight: FontWeight.w300,
            showIcon: false,
            color: globalConfig.isVoiceMode == false ? const Color(0xFF672CBC) : Colors.grey,
            action: SystemAction(() => globalConfig.setVoiceMode(false))
          )
        ]),
      ),
      DisclosureButtonModel.withDefaultTextStyle(
        text: "Profile Setting",
        action: NavigateAction(AppRoutes.profile),
      ),
      DisclosureButtonModel.withDefaultTextStyle(
        text: "Help & Support",
        action: ExpandNestedDrawerAction([]),
      ),
      DisclosureButtonModel.withDefaultTextStyle(
        text: "logout",
        action: SystemAction(() => {}),
        showIcon: false,
        color: Color(0xFFEA4335)
      ),
    ];
  }
}