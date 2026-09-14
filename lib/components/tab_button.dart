import 'package:flutter/material.dart';
import 'package:inquran/common/app_color.dart';

/// Tab-style toggle button, matching the Surah/Juz tabs in the surah list.
class TabButton extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const TabButton({
    super.key,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const activeColor = AppColors.primary;
    final inactiveColor = Colors.grey;

    return Semantics(
      button: true,
      selected: isActive,
      label: 'Tab $label',
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          decoration: BoxDecoration(
            // color: Colors.white,
            border: Border(
              bottom: BorderSide(
                color: isActive ? activeColor : Colors.grey.shade200,
                width: 3,
              ),
            ),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: isActive ? activeColor : inactiveColor,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
