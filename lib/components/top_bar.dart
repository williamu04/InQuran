import 'package:flutter/material.dart';

class TopBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? leftIcon;
  final Widget? rightIcon;
  final Widget? middle;
  final Color backgroundColor;

  const TopBar({
    super.key,
    this.leftIcon,
    this.rightIcon,
    this.middle,
    this.backgroundColor = Colors.transparent,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          leftIcon ?? SizedBox.shrink(),

          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (middle != null)
                  Semantics(header: true, child: middle!)
                else
                  const SizedBox.shrink(),
              ],
            ),
          ),

          rightIcon ?? SizedBox.shrink(),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
