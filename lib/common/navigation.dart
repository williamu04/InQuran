import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:inquran/data/aggregate/surah.dart';
import 'package:inquran/data/local/db/app_database.dart';
import 'package:inquran/dto/juz.dart';
import 'package:inquran/dto/surah.dart';
import 'package:inquran/routes/route.dart';

void navigateToSurah(BuildContext context, SurahInfoDto surah) {
  context.push(
    Uri(
      path: AppRoutes.surah.path,
      queryParameters: {
        'startSurahId': surah.number.toString(),
        'startSurahAyah': '1',
        'endSurahId': surah.number.toString(),
        'endSurahAyah': surah.totalAyah.toString(),
        'loadType': 'surah',
      },
    ).toString(),
  );
}

/// Navigates to a surah starting at a specific ayah (voice command target).
void navigateToSurahAyah(BuildContext context, SurahInfoDto surah, int ayahNumber) {
  final clampedAyah = ayahNumber.clamp(1, surah.totalAyah);
  context.push(
    Uri(
      path: AppRoutes.surah.path,
      queryParameters: {
        'startSurahId': surah.number.toString(),
        'startSurahAyah': clampedAyah.toString(),
        'endSurahId': surah.number.toString(),
        'endSurahAyah': surah.totalAyah.toString(),
        'loadType': 'surah',
      },
    ).toString(),
  );
}

void navigateToHome(BuildContext context) {
  context.go(AppRoutes.home.path);
}

void navigateToSurahList(BuildContext context) {
  context.go(AppRoutes.surahList.path);
}

void navigateToDoaList(BuildContext context) {
  context.go(AppRoutes.doaList.path);
}

void navigateToSearch(BuildContext context) {
  context.go(AppRoutes.search.path);
}

void navigateToFavorites(BuildContext context) {
  context.go(AppRoutes.favorites.path);
}

void navigateToJuz(BuildContext context, JuzInfoDto juz) {
  context.push(
    Uri(
      path: AppRoutes.surah.path,
      queryParameters: {
        'startSurahId': juz.startSurahNumber.toString(),
        'startSurahAyah': juz.startAyahNumber.toString(),
        'endSurahId': juz.endSurahNumber.toString(),
        'endSurahAyah': juz.endAyahNumber.toString(),
        'loadType': 'juz',
      },
    ).toString(),
  );
}

void navigateToDoaCategory(BuildContext context, DoaCategoryData category) {
  context.push(
    Uri(
      path: AppRoutes.doa.path,
      queryParameters: {
        'categoryId': category.id.toString(),
        'categoryName': category.nama,
      },
    ).toString(),
  );
}

void navigateToQibla(BuildContext context) {
  context.push(AppRoutes.qibla.path);
}

void navigateToPrayer(BuildContext context) {
  context.push(AppRoutes.prayer.path);
}

void navigateToAyah(BuildContext context, AyahWithSurah ayah) {
  context.push(
    Uri(
      path: AppRoutes.surah.path,
      queryParameters: {
        'startSurahId': ayah.surah.id.toString(),
        'startSurahAyah': ayah.ayah.ayahNumber.toString(),
        'endSurahId': ayah.surah.id.toString(),
        'endSurahAyah': ayah.ayah.ayahNumber.toString(),
        'loadType': 'surah',
      },
    ).toString(),
  );
}
