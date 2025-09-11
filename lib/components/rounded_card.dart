import 'package:flutter/material.dart';

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
              color: Color(0x50240F4F),
              blurRadius: 15,
              offset: Offset(0, 12),
            ),
          ],
    ),
    child: Container(
      padding:
          padding ??
          const EdgeInsets.only(top: 80, left: 40, right: 40, bottom: 20),
      decoration: BoxDecoration(
        gradient:
            gradient ??
            const LinearGradient(
              colors: [Color(0xFF863ED5), Color(0xFF240F4F)],
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
