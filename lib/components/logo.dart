
  import 'package:flutter/material.dart';

Widget buildLogo() {
    return Container(
      height: 81,
      width: 130,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Image.asset(
        'assets/img/logoSplashScreen.png',
        fit: BoxFit.contain,
      ),
    );
  }