import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

Widget buildLogo({bool decorative = true}) {
  return ExcludeSemantics(
    excluding: decorative,
    child: Container(
      height: 120,
      width: 160,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Image.asset(
        'assets/img/logoSplashScreen.png',
        fit: BoxFit.contain,
        semanticLabel: decorative ? null : 'Logo aplikasi InQuran',
      ),
    ),
  );
}
