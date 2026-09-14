import 'package:flutter/material.dart';
import 'package:inquran/routes/route_model.dart';
import 'package:inquran/common/app_color.dart';

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

class DisclosureButtonModel {
  final DisclosureButtonAction action;
  final bool showIcon;
  final Text textWidget;
  final String? semanticLabel;
  final bool? selected;

  DisclosureButtonModel({
    required this.action,
    this.showIcon = true,
    required this.textWidget,
    this.semanticLabel,
    this.selected,
  });

  DisclosureButtonModel.withDefaultTextStyle({
    required this.action,
    required String text,
    double fontSize = 16,
    FontWeight fontWeight = FontWeight.bold,
    Color color = AppColors.primary,
    this.showIcon = true,
    this.semanticLabel,
    this.selected,
  }) : textWidget = Text(
          text,
          style: TextStyle(
            fontSize: fontSize,
            color: color,
            fontWeight: fontWeight,
          ),
        );

  String get accessibilityLabel => semanticLabel ?? textWidget.data ?? '';
}