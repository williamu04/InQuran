import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:mtqmnuns/models/disclosure_button.dart';

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
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              model.text,
              style: TextStyle(
                fontSize: 16,
                color: model.color,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (model.showIcon)
              Icon(
                isExpanded ? LucideIcons.chevronDown : LucideIcons.chevronRight,
                size: 20,
                color: model.color,
              ),
          ],
        ),
      ),
    );
  }
}
