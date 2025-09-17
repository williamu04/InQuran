import 'package:flutter/material.dart';
import 'package:mtqmnuns/state/disclosure_button.dart';

class DisclosureButtonModel {
  final String text;
  final DisclosureButtonAction action;
  final bool showIcon;
  Color color;

  DisclosureButtonModel({
    required this.text,
    required this.action,
    this.showIcon = true,
    this.color = const Color(0xFF672CBC)
  });
}
