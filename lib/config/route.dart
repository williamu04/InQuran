import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:mtqmnuns/data/local/dao/ayah_dao.dart';
import 'package:mtqmnuns/data/local/dao/surah_dao.dart';
import 'package:mtqmnuns/data/local/db/app_database.dart';
import 'package:mtqmnuns/screens/book.dart';
import 'package:mtqmnuns/screens/calendar.dart';
import 'package:mtqmnuns/screens/etc.dart';
import 'package:mtqmnuns/screens/favorites.dart';
import 'package:mtqmnuns/screens/profile.dart';
import 'package:mtqmnuns/screens/qibla.dart';
import 'package:mtqmnuns/screens/search.dart';
import 'package:mtqmnuns/screens/duas.dart';
import 'package:mtqmnuns/screens/home.dart';
import 'package:mtqmnuns/screens/times.dart';

class AppRouteConfig {
  final String text;
  final String path;
  final Widget screen;
  final IconData icon;

  const AppRouteConfig({
    required this.text,
    required this.path,
    required this.screen,
    required this.icon,
  });
}

class AppRoutes {
  static const home = AppRouteConfig(
    text: 'Home',
    path: '/',
    screen: HomeScreen(),
    icon: LucideIcons.house,
  );

  static const book = AppRouteConfig(
    text: 'The Holy Quran',
    path: '/book',
    screen:  BookScreen(),
    icon: LucideIcons.bookOpen,
  );

  static const search = AppRouteConfig(
    text: 'Search',
    path: '/search',
    screen: SearchScreen(),
    icon: LucideIcons.search,
  );

  static const duas = AppRouteConfig(
    text: 'Duas Collection',
    path: '/duas',
    screen: DuasScreen(),
    icon: LucideIcons.handHeart,
  );

  static const profile = AppRouteConfig(
    text: 'Profile',
    path: '/profile',
    screen: ProfileScreen(),
    icon: LucideIcons.user,
  );

  static const prayer = AppRouteConfig(
    text: 'Prayer Times',
    path: '/times',
    screen: PrayerTimeScreen(), // Placeholder, replace with actual screen
    icon: LucideIcons.hourglass,
  );

  static const qibla = AppRouteConfig(
    text: 'Prayer Qibla',
    path: '/qibla',
    screen: QiblaScreen(), // Placeholder, replace with actual screen
    icon: LucideIcons.compass,
  );

  static const favorites = AppRouteConfig(
    text: 'Favorites',
    path: '/favorite',
    screen: FavoriteScreen(), // Placeholder, replace with actual screen
    icon: LucideIcons.bookMarked,
  );

  static const calendar = AppRouteConfig(
    text: 'Calendar',
    path: '/calendar',
    screen: CalendarScreen(), // Placeholder, replace with actual screen
    icon: LucideIcons.calendar,
  );

  static const etc = AppRouteConfig(
    text: 'Etc',
    path: '/etc',
    screen: EtcScreen(),
    icon: LucideIcons.bell
  );

  static const List<AppRouteConfig> homeMenu = [
    book,
    duas,
    prayer,
    qibla,
    favorites,
    calendar,
    etc,
  ];

  static const List<AppRouteConfig> bottomNav = [
    book,
    search,
    home,
    duas,
    profile,
  ];

  static const List<AppRouteConfig> all = [
    book,
    search,
    home,
    duas,
    profile,
    prayer,
    qibla,
    favorites,
    calendar,
    etc
  ];
}

