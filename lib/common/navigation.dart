import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mtqmnuns/dto/surah.dart';
import 'package:mtqmnuns/routes/route.dart';

void navigateToSurah(BuildContext context, SurahInfoDto surah) {
  context.push(Uri(
    path: AppRoutes.surah.path,
    queryParameters: {
      'id': '${surah.number}',
      'ayah': '1',
    },
  ).toString());
}