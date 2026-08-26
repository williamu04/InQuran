import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:inquran/state/disclosure_button.dart';
import 'package:inquran/common/app_color.dart';

class DisclosureButton extends StatelessWidget {
  final DisclosureButtonModel model;
  final bool isExpanded;
  final Function() onTap;

  const DisclosureButton({
    super.key,
    required this.model,
    required this.isExpanded,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          model.textWidget,
          if (model.showIcon)
            Icon(
              isExpanded ? LucideIcons.chevronDown : LucideIcons.chevronRight,
              size: 20,
              color: model.textWidget.style?.color ??  AppColors.primary,
            ),
        ],
      ),
    );
  }
}
