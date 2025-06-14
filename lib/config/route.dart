import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:mtqmnuns/screens/book.dart';
import 'package:mtqmnuns/screens/calendar.dart';
import 'package:mtqmnuns/screens/etc.dart';
import 'package:mtqmnuns/screens/favorites.dart';
import 'package:mtqmnuns/screens/profile.dart';
import 'package:mtqmnuns/screens/qibla.dart';
import 'package:mtqmnuns/screens/search.dart';
import 'package:mtqmnuns/screens/duas.dart';
import 'package:mtqmnuns/screens/home.dart';
import 'package:mtqmnuns/screens/signup.dart';
import 'package:mtqmnuns/screens/times.dart';

class AppRouteConfig {
  final String title;
  final String path;
  final Widget screen;
  final IconData icon;
  final bool isHasPurpleBanner;

  const AppRouteConfig({
    required this.title,
    required this.path,
    required this.screen,
    required this.icon,
    required this.isHasPurpleBanner,
  });
}

class AppRoutes {
  static const signUp = AppRouteConfig(
    title: 'Sign Up',
    path: '/signup',
    screen: SignUpScreen(),
    icon: LucideIcons.user,
    isHasPurpleBanner: false,
  );

  static const home = AppRouteConfig(
    title: 'QuranApp',
    path: '/',
    screen: HomeScreen(),
    icon: LucideIcons.house,
    isHasPurpleBanner: true,
  );

  static const book = AppRouteConfig(
    title: 'The Holy Quran',
    path: '/book',
    screen:  BookScreen(),
    icon: LucideIcons.bookOpen,
    isHasPurpleBanner: false,
  );

  static const search = AppRouteConfig(
    title: 'Explore',
    path: '/search',
    screen: SearchScreen(),
    icon: LucideIcons.search,
    isHasPurpleBanner: true,
  );

  static const duas = AppRouteConfig(
    title: 'Duas Collection',
    path: '/duas',
    screen: DuasScreen(),
    icon: LucideIcons.handHeart,
    isHasPurpleBanner: true,
  );

  static const profile = AppRouteConfig(
    title: 'Account Profile',
    path: '/profile',
    screen: ProfileScreen(),
    icon: LucideIcons.user,
    isHasPurpleBanner: true,
  );

  static const prayer = AppRouteConfig(
    title: 'Prayer Times',
    path: '/times',
    screen: PrayerTimeScreen(), // Placeholder, replace with actual screen
    icon: LucideIcons.hourglass,
    isHasPurpleBanner: false,
  );

  static const qibla = AppRouteConfig(
    title: 'Prayer Qibla',
    path: '/qibla',
    screen: QiblaScreen(), // Placeholder, replace with actual screen
    icon: LucideIcons.compass,
    isHasPurpleBanner: false,
  );

  static const favorites = AppRouteConfig(
    title: 'Favorites',
    path: '/favorite',
    screen: FavoriteScreen(), // Placeholder, replace with actual screen
    icon: LucideIcons.bookMarked,
    isHasPurpleBanner: false,
  );

  static const calendar = AppRouteConfig(
    title: 'Calendar',
    path: '/calendar',
    screen: CalendarScreen(), // Placeholder, replace with actual screen
    icon: LucideIcons.calendar,
    isHasPurpleBanner: false,
  );

  static const etc = AppRouteConfig(
    title: 'Etc',
    path: '/etc',
    screen: EtcScreen(),
    icon: LucideIcons.bell,
    isHasPurpleBanner: false,
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
    etc,
    signUp
  ];

  static AppRouteConfig getRouteByPath(String path) {
    return  AppRoutes.all.firstWhere(
      (route) => route.path == path
    );
  }

}

