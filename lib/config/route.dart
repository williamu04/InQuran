import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
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
    icon: LucideIcons.home,
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

  static const List<AppRouteConfig> all = [
    book,
    search,
    home,
    duas,
    profile,
  ];
}

