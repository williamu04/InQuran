import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:mtqmnuns/components/top_bar.dart';
import 'package:mtqmnuns/viewmodel/drawer.dart';
import 'package:provider/provider.dart';

class TopBarIconModel {
  IconData icon;
  VoidCallback onPressed;
  Color color;
  TopBarIconModel({required this.icon, required this.onPressed, this.color = Colors.white});
}

class TopBarUtility {
  static Widget topBarIcon({required TopBarIconModel topBarModel}) {
    return IconButton(
      icon: Icon(topBarModel.icon, color: topBarModel.color),
      onPressed: topBarModel.onPressed,
    );
  }

  static openMenuDrawer(BuildContext context) {
    final vm = context.read<MenuSlideDrawerViewModel>();
    vm.open();
  }

  static openSettingDrawer(BuildContext context) {
    final vm = context.read<SettingSlideDrawerViewModel>();
    vm.open();
  }

  static buildDefaultTopBar({
    required BuildContext context, 
    TopBarIconModel? leftIcon, 
    TopBarIconModel? rightIcon, 
    String? title,
    Color? titleColor
  }) {
      return TopBar(
        leftIcon : topBarIcon(topBarModel: leftIcon ?? menuIcon(context: context)),
        rightIcon : topBarIcon(topBarModel: rightIcon ?? settingIcon(context: context)),
        middle: title == null ? null : Center(
          child: Text(
            title,
            style: TextStyle(
              color: titleColor ?? Colors.white,
              fontWeight: FontWeight.w900
            ),
          ),
        ),
    );
  }

  static buildPurpleTitleTopbar({
    required BuildContext context, 
    TopBarIconModel? leftIcon, 
    TopBarIconModel? rightIcon, 
    String? title,
  }) {
    return buildDefaultTopBar(
      context: context, 
      leftIcon: leftIcon ?? menuIcon(context: context, buttonColor: Colors.grey),
      rightIcon: rightIcon ?? settingIcon(context: context, buttonColor: Colors.grey),
      title: title,
      titleColor: Color(0xFF672CBC)
    );

  }


  static TopBarIconModel menuIcon({required BuildContext context, Color? buttonColor}) {
    return TopBarIconModel(icon: LucideIcons.alignLeft, onPressed: () => openMenuDrawer(context), color: buttonColor ?? Colors.white);
  }

  static TopBarIconModel settingIcon({required BuildContext context, Color? buttonColor}) {
    return TopBarIconModel(icon: LucideIcons.settings, onPressed: () => openSettingDrawer(context), color: buttonColor ?? Colors.white);
  }
}
  
