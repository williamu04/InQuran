import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:mtqmnuns/components/disclosure_button.dart';
import 'package:mtqmnuns/components/drawer_generic_helper.dart';
import 'package:mtqmnuns/components/rounded_card.dart';
import 'package:mtqmnuns/config/global.dart';
import 'package:mtqmnuns/models/disclosure_button.dart';
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
            color: globalConfig.isVoiceMode == true ? const Color(0xFF672CBC) : Colors.grey,
            action: SystemAction(() => globalConfig.setVoiceMode(true))
          ),
          DisclosureButtonModel(
            text: "Off",
            showIcon: false,
            color: globalConfig.isVoiceMode == false ? const Color(0xFF672CBC) : Colors.grey,
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
        action: SystemAction(() => {}),
        showIcon: false,
        color: Color(0xFFEA4335)
      ),
    ];
  }
}