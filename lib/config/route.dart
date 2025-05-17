import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:mtqmnuns/screens/book.dart';
import 'package:mtqmnuns/screens/profile.dart';
import 'package:mtqmnuns/screens/search.dart';
import 'package:mtqmnuns/screens/duas.dart';
import 'package:mtqmnuns/screens/home.dart';

class AppRouteConfig {
  final String path;
  final Widget screen;
  final IconData icon;

  const AppRouteConfig({
    required this.path,
    required this.screen,
    required this.icon,
  });
}

class AppRoutes {
  static const home = AppRouteConfig(
    path: '/',
    screen: HomeScreen(),
    icon: LucideIcons.house,
  );

  static const book = AppRouteConfig(
    path: '/book',
    screen: BookScreen(),
    icon: LucideIcons.bookOpen,
  );

  static const search = AppRouteConfig(
    path: '/search',
    screen: SearchScreen(),
    icon: LucideIcons.search,
  );

  static const duas = AppRouteConfig(
    path: '/duas',
    screen: DuasScreen(),
    icon: Icons.volunteer_activism_outlined,
  );

  static const profile = AppRouteConfig(
    path: '/profile',
    screen: ProfileScreen(),
    icon: LucideIcons.user,
  );

  static const prayer = AppRouteConfig(
    path: '/',
    screen: HomeScreen(), // Placeholder, replace with actual screen
    icon: LucideIcons.hourglass,
  );

  static const qibla = AppRouteConfig(
    path: '/',
    screen: HomeScreen(), // Placeholder, replace with actual screen
    icon: LucideIcons.compass,
  );

  static const favorites = AppRouteConfig(
    path: '/',
    screen: HomeScreen(), // Placeholder, replace with actual screen
    icon: LucideIcons.bookMarked,
  );

  static const calendar = AppRouteConfig(
    path: '/',
    screen: HomeScreen(), // Placeholder, replace with actual screen
    icon: LucideIcons.calendar,
  );

  static const etc = AppRouteConfig(
    path: '/',
    screen: HomeScreen(),
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
  ];
}

