import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:mtqmnuns/config/route.dart';
import 'package:mtqmnuns/screens/explore.dart';
import 'package:mtqmnuns/screens/surah_list.dart';
import 'package:mtqmnuns/screens/calendar.dart';
import 'package:mtqmnuns/screens/etc.dart';
import 'package:mtqmnuns/screens/favorites.dart';
import 'package:mtqmnuns/screens/intro.dart';
import 'package:mtqmnuns/screens/login.dart';
import 'package:mtqmnuns/screens/profile.dart';
import 'package:mtqmnuns/screens/qibla.dart';
import 'package:mtqmnuns/screens/search.dart';
import 'package:mtqmnuns/screens/duas.dart';
import 'package:mtqmnuns/screens/home.dart';
import 'package:mtqmnuns/screens/signup.dart';
import 'package:mtqmnuns/screens/surah.dart';
import 'package:mtqmnuns/screens/splash.dart';
import 'package:mtqmnuns/screens/times.dart';
import 'package:mtqmnuns/viewmodel/surah.dart';
import 'package:provider/provider.dart';

class AppRoutes {
  static final signUp = AppRoute(
    title: 'Sign Up',
    path: '/signup',
    pageBuilder: (context, state) => NoTransitionPage(child: SignUpScreen()),
    icon: LucideIcons.user,
    isHasPurpleBanner: false,
    isHasTopBar: false,
    isHasBottomBar: false,
  );

  static final intro = AppRoute(
    title: 'intro',
    path: '/intro',
    pageBuilder: (context, state) => NoTransitionPage(child: IntroScreen()),
    icon: LucideIcons.listStart,
    isHasPurpleBanner: false,
    isHasTopBar: false,
    isHasBottomBar: false,
  );

  static final login = AppRoute(
    title: 'login',
    path: '/login',
    pageBuilder: (context, state) => NoTransitionPage(child: LoginScreen()),
    icon: LucideIcons.user,
    isHasPurpleBanner: false,
    isHasTopBar: false,
    isHasBottomBar: false,
  );

  static final splashScreen = AppRoute(
    title: 'Splash Screen',
    path: '/splash',
    pageBuilder: (context, state) => NoTransitionPage(child: SplashScreen()),
    icon: LucideIcons.user,
    isHasPurpleBanner: false,
    isHasTopBar: false,
    isHasBottomBar: false,
  );

  static final home = AppRoute(
    title: 'QuranApp',
    path: '/',
    isHasPurpleBanner: true,
    isHasTopBar: true,
    isHasBottomBar: true,
    pageBuilder: (context, state) => NoTransitionPage(child: HomeScreen()),
    icon: LucideIcons.house,
  );

  static final surahList = AppRoute(
    title: 'The Holy Quran',
    path: '/surah/list',
    pageBuilder: (context, state) => NoTransitionPage(child: SurahListScreen()),
    icon: LucideIcons.bookOpen,
    isHasPurpleBanner: false,
    isHasTopBar: true,
    isHasBottomBar: true,
  );

  static final search = AppRoute(
    title: 'Explore',
    path: '/search',
    pageBuilder: (context, state) => NoTransitionPage(child: SearchScreen()),
    icon: LucideIcons.search,
    isHasPurpleBanner: true,
    isHasTopBar: true,
    isHasBottomBar: true,
  );

  static final duas = AppRoute(
    title: 'Duas Collection',
    path: '/duas',
    pageBuilder: (context, state) => NoTransitionPage(child: DuasScreen()),
    icon: LucideIcons.handHeart,
    isHasPurpleBanner: true,
    isHasTopBar: true,
    isHasBottomBar: true,
  );

  static final profile = AppRoute(
    title: 'Account Profile',
    path: '/profile',
    pageBuilder: (context, state) => NoTransitionPage(child: ProfileScreen()),
    icon: LucideIcons.user,
    isHasPurpleBanner: true,
    isHasTopBar: true,
    isHasBottomBar: true,
  );

  static final prayer = AppRoute(
    title: 'Prayer Times',
    path: '/times',
    pageBuilder:
        (context, state) => NoTransitionPage(child: PrayerTimeScreen()),
    icon: LucideIcons.hourglass,
    isHasPurpleBanner: false,
    isHasTopBar: true,
    isHasBottomBar: true,
  );

  static final qibla = AppRoute(
    title: 'Prayer Qibla',
    path: '/qibla',
    pageBuilder: (context, state) => NoTransitionPage(child: QiblaScreen()),
    icon: LucideIcons.compass,
    isHasPurpleBanner: false,
    isHasTopBar: true,
    isHasBottomBar: true,
  );

  static final favorites = AppRoute(
    title: 'Favorites',
    path: '/favorite',
    pageBuilder: (context, state) => NoTransitionPage(child: FavoriteScreen()),
    icon: LucideIcons.bookMarked,
    isHasPurpleBanner: false,
    isHasTopBar: true,
    isHasBottomBar: true,
  );

  static final calendar = AppRoute(
    title: 'Calendar',
    path: '/calendar',
    pageBuilder: (context, state) => NoTransitionPage(child: CalendarScreen()),
    icon: LucideIcons.calendar,
    isHasPurpleBanner: false,
    isHasTopBar: true,
    isHasBottomBar: true,
  );

  static final explore = AppRoute(
    title: 'Explore',
    path: '/explore',
    pageBuilder: (context, state) => NoTransitionPage(child: ExploreScreen()),
    icon: LucideIcons.search,
    isHasPurpleBanner: false,
    isHasTopBar: true,
    isHasBottomBar: true,
  );

  static final etc = AppRoute(
    title: 'Etc',
    path: '/etc',
    pageBuilder: (context, state) => NoTransitionPage(child: EtcScreen()),
    icon: LucideIcons.bell,
    isHasPurpleBanner: false,
    isHasTopBar: true,
    isHasBottomBar: true,
  );

  static final surah = AppRoute(
    title: 'Surah Screen',
    path: '/surah',
    pageBuilder: (context, state) {
      int? surahId = int.tryParse(state.uri.queryParameters['id'] ?? '');
      return NoTransitionPage(child: SurahScreen(surahId: surahId,));
    },
    icon: LucideIcons.book,
    isHasPurpleBanner: false,
    isHasTopBar: true,
    isHasBottomBar: true,
  );

  static final List<AppRoute> homeMenu = [
    surahList,
    duas,
    prayer,
    qibla,
    favorites,
    search,
  ];

  static final List<AppRoute> bottomNav = [
    surahList,
    search,
    home,
    duas,
    profile,
  ];

  static final List<AppRoute> all = [
    surahList,
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
    login,
    surah,
    splashScreen,
    intro,
  ];

  static AppRoute getRouteByPath(String path) {
    final cleanPath = Uri.parse(path).path;
    return AppRoutes.all.firstWhere((route) => route.path == cleanPath);
  }
}
