import 'dart:ui';
import 'package:mtqmnuns/models/disclosure_button.dart';
import 'package:mtqmnuns/routes/route_model.dart';

sealed class DisclosureButtonAction {}

class NavigateAction extends DisclosureButtonAction {
  final AppRoute route;
  NavigateAction(this.route);
}

class SystemAction extends DisclosureButtonAction {
  final VoidCallback function;
  SystemAction(this.function);
}

class ExpandNestedDrawerAction extends DisclosureButtonAction {
  final List<DisclosureButtonModel> nestedButtons;
  ExpandNestedDrawerAction(this.nestedButtons);
}