import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mtqmnuns/dto/juz.dart';
import 'package:mtqmnuns/dto/surah.dart';
import 'package:mtqmnuns/routes/route.dart';

void navigateToSurah(BuildContext context, SurahInfoDto surah) {
  context.push(Uri(
    path: AppRoutes.surah.path,
    queryParameters: {
    'startSurahId': surah.number.toString(),
    'startSurahAyah': '1',
    'endSurahId': surah.number.toString(),
    'endSurahAyah': surah.totalAyah.toString(),
    'loadType' : 'surah' 
    },
  ).toString());
}

void navigateToJuz(BuildContext context, JuzInfoDto juz) {
  context.push(Uri(
    path: AppRoutes.surah.path,
    queryParameters: {
    'startSurahId': juz.startSurahNumber.toString(),
    'startSurahAyah': juz.startAyahNumber.toString(),
    'endSurahId': juz.endSurahNumber.toString(),
    'endSurahAyah': juz.endAyahNumber.toString(),
    'loadType' : 'juz' 
    },
  ).toString());
}