import 'package:flutter/material.dart';

Widget normal_button(Function() onPressed) {
  
  return GestureDetector(
    onTap: onPressed,

  ) 
}