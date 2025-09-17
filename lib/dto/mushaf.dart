import 'package:flutter/material.dart';
import 'package:mtqmnuns/dto/surah.dart';

class MushafPagesItem {
  final String text;
  final AyahWithSurahDto ayahInfo;
  final TextStyle style;
  final Size size;
  MushafPagesItem(this.text, this.style, this.size, this.ayahInfo);
}