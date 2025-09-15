

import 'dart:ui';

import 'package:flutter/material.dart';

class MushafViewModel {

}

Size measureText(
  String text,
  TextStyle style,
  double maxWidth,
) {
  final tp = TextPainter(
    text: TextSpan(text: text, style: style),
    textDirection: TextDirection.ltr,
    maxLines: null, // allow wrapping
  )..layout(maxWidth: maxWidth);

  return Size(tp.width, tp.height);
}
