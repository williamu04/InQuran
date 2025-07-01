import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
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
import 'package:mtqmnuns/screens/signup.dart';
import 'package:mtqmnuns/screens/surah.dart';
import 'package:mtqmnuns/screens/splash_screen.dart';
import 'package:mtqmnuns/screens/times.dart';

class AppRouteConfig {
  final String title;
  final String path;
  final IconData icon;
  final bool isHasPurpleBanner;
  final bool isHasBar;
  final Page<dynamic> Function(BuildContext context, GoRouterState state)
  pageBuilder;
  final Future<String> Function(GoRouterState)? dynamicTitleBuilder;

  const AppRouteConfig({
    required this.title,
    required this.path,
    required this.pageBuilder,
    required this.icon,
    required this.isHasBar,
    required this.isHasPurpleBanner,
    this.dynamicTitleBuilder,
  });
}

class AppRoutes {
  static final signUp = AppRouteConfig(
    title: 'Sign Up',
    path: '/signup',
    pageBuilder: (context, state) => NoTransitionPage(child: SignUpScreen()),
    icon: LucideIcons.user,
    isHasPurpleBanner: false,
    isHasBar: false,
  );

  static const splashScreen = AppRouteConfig(
    title: 'Splash Screen',
    path: '/splash',
    screen: SplashScreen(),
    icon: LucideIcons.user,
    isHasPurpleBanner: false,
    isHasBar: false,
  );

  static const splashScreen = AppRouteConfig(
    title: 'Splash Screen',
    path: '/splash',
    screen: SplashScreen(),
    icon: LucideIcons.user,
    isHasPurpleBanner: false,
  );

  static final home = AppRouteConfig(
    title: 'QuranApp',
    path: '/',
    pageBuilder: (context, state) => NoTransitionPage(child: HomeScreen()),
    icon: LucideIcons.house,
    isHasPurpleBanner: true,
    isHasBar: true,
  );

  static final book = AppRouteConfig(
    title: 'The Holy Quran',
    path: '/book',
    pageBuilder: (context, state) => NoTransitionPage(child: BookScreen()),
    icon: LucideIcons.bookOpen,
    isHasPurpleBanner: false,
    isHasBar: true,
  );

  static final search = AppRouteConfig(
    title: 'Explore',
    path: '/search',
    pageBuilder: (context, state) => NoTransitionPage(child: SearchScreen()),
    icon: LucideIcons.search,
    isHasPurpleBanner: true,
    isHasBar: true,
  );

  static final duas = AppRouteConfig(
    title: 'Duas Collection',
    path: '/duas',
    pageBuilder: (context, state) => NoTransitionPage(child: DuasScreen()),
    icon: LucideIcons.handHeart,
    isHasPurpleBanner: true,
    isHasBar: true,
  );

  static final profile = AppRouteConfig(
    title: 'Account Profile',
    path: '/profile',
    pageBuilder: (context, state) => NoTransitionPage(child: ProfileScreen()),
    icon: LucideIcons.user,
    isHasPurpleBanner: true,
    isHasBar: true,
  );

  static final prayer = AppRouteConfig(
    title: 'Prayer Times',
    path: '/times',
    pageBuilder:
        (context, state) => NoTransitionPage(child: PrayerTimeScreen()),
    icon: LucideIcons.hourglass,
    isHasPurpleBanner: false,
    isHasBar: true,
  );

  static final qibla = AppRouteConfig(
    title: 'Prayer Qibla',
    path: '/qibla',
    pageBuilder: (context, state) => NoTransitionPage(child: QiblaScreen()),
    icon: LucideIcons.compass,
    isHasPurpleBanner: false,
    isHasBar: true,
  );

  static final favorites = AppRouteConfig(
    title: 'Favorites',
    path: '/favorite',
    pageBuilder: (context, state) => NoTransitionPage(child: FavoriteScreen()),
    icon: LucideIcons.bookMarked,
    isHasPurpleBanner: false,
    isHasBar: true,
  );

  static final calendar = AppRouteConfig(
    title: 'Calendar',
    path: '/calendar',
    pageBuilder: (context, state) => NoTransitionPage(child: CalendarScreen()),
    icon: LucideIcons.calendar,
    isHasPurpleBanner: false,
    isHasBar: true,
  );

  static final etc = AppRouteConfig(
    title: 'Etc',
    path: '/etc',
    pageBuilder: (context, state) => NoTransitionPage(child: EtcScreen()),
    icon: LucideIcons.bell,
    isHasPurpleBanner: false,
    isHasBar: true,
  );

  static final surah = AppRouteConfig(
    title: 'Surah Screen',
    path: '/surah',
    pageBuilder: (context, state) {
      return NoTransitionPage(child: SurahScreen(state: state));
    },
    icon: LucideIcons.book,
    isHasPurpleBanner: false,
    isHasBar: true,
  );

  static final List<AppRouteConfig> homeMenu = [
    book,
    duas,
    prayer,
    qibla,
    favorites,
    calendar,
    etc,
  ];

  static final List<AppRouteConfig> bottomNav = [
    book,
    search,
    home,
    duas,
    profile,
  ];

  static final List<AppRouteConfig> all = [
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
    signUp,
    surah,
  ];

  static AppRouteConfig getRouteByPath(String path) {
    final cleanPath = Uri.parse(path).path;
    return AppRoutes.all.firstWhere((route) => route.path == cleanPath);
  }
}
