import 'package:flutter/material.dart';
import 'package:inquran/common/app_color.dart';

Widget roundedCard({
  required Widget child,
  EdgeInsetsGeometry? padding,
  Gradient? gradient,
  double borderRadius = 20,
  List<BoxShadow>? boxShadow,
  bool allRounded = false,
}) {
  return Container(
    width: double.infinity,
    decoration: BoxDecoration(
      borderRadius:
          allRounded
              ? BorderRadius.circular(borderRadius)
              : BorderRadius.only(
                bottomLeft: Radius.circular(borderRadius),
                bottomRight: Radius.circular(borderRadius),
              ),
      boxShadow:
          boxShadow ??
          [
            BoxShadow(
              color: AppColors.darkestPurple.withValues(alpha: 0.31),
              blurRadius: 15,
              offset: Offset(0, 12),
            ),
          ],
    ),
    child: Container(
      padding: padding ?? const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        gradient:
            gradient ??
            const LinearGradient(
              colors: [AppColors.purpleAccent, AppColors.darkestPurple],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
        borderRadius:
            allRounded
                ? BorderRadius.circular(borderRadius)
                : BorderRadius.only(
                  bottomLeft: Radius.circular(borderRadius),
                  bottomRight: Radius.circular(borderRadius),
                ),
      ),
      child: child,
    ),
  );
}
