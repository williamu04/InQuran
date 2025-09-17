import 'package:flutter/material.dart';
import 'package:mtqmnuns/state/disclosure_button.dart';

class DisclosureButtonModel {
  final DisclosureButtonAction action;
  final bool showIcon;
  final Text textWidget;

  DisclosureButtonModel({
    required this.action,
    this.showIcon = true,
    required this.textWidget,
  });

  DisclosureButtonModel.withDefaultTextStyle({
    required this.action,
    required String text,
    double fontSize = 16,
    FontWeight fontWeight = FontWeight.bold,
    Color color = const Color(0xFF672CBC),
    this.showIcon = true,
  }) : textWidget = Text(
          text,
          style: TextStyle(
            fontSize: fontSize,
            color: color, 
            fontWeight: fontWeight,
          ),
        );
}
