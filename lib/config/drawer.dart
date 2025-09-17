
import 'package:flutter/material.dart';
import 'package:mtqmnuns/models/disclosure_button.dart';
import 'package:mtqmnuns/state/disclosure_button.dart';

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
}
