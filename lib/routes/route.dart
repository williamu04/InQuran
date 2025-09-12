import 'package:go_router/go_router.dart';
import 'package:mtqmnuns/routes/route_model.dart';
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

class AppRoutes {
  static final signUp = AppRoute(
    path: '/signup',
    pageBuilder: (context, state) => NoTransitionPage(child: SignUpScreen()),
    isHasBottomBar: false,
  );

  static final intro = AppRoute(
    path: '/intro',
    pageBuilder: (context, state) => NoTransitionPage(child: IntroScreen()),
    isHasBottomBar: false,
  );

  static final login = AppRoute(
    path: '/login',
    pageBuilder: (context, state) => NoTransitionPage(child: LoginScreen()),
    isHasBottomBar: false,
  );

  static final splashScreen = AppRoute(
    path: '/splash',
    pageBuilder: (context, state) => NoTransitionPage(child: SplashScreen()),
    isHasBottomBar: false,
  );

  static final home = AppRoute(
    path: '/',
    isHasBottomBar: true,
    pageBuilder: (context, state) => NoTransitionPage(child: HomeScreen()),
  );

  static final surahList = AppRoute(
    path: '/surah/list',
    pageBuilder: (context, state) => NoTransitionPage(child: SurahListScreen()),
    isHasBottomBar: true,
  );

  static final search = AppRoute(
    path: '/search',
    pageBuilder: (context, state) => NoTransitionPage(child: SearchScreen()),
    isHasBottomBar: true,
  );

  static final duas = AppRoute(
    path: '/duas',
    pageBuilder: (context, state) => NoTransitionPage(child: DuasScreen()),
    isHasBottomBar: true,
  );

  static final profile = AppRoute(
    path: '/profile',
    pageBuilder: (context, state) => NoTransitionPage(child: ProfileScreen()),
    isHasBottomBar: true,
  );

  static final prayer = AppRoute(
    path: '/times',
    pageBuilder: (context, state) => NoTransitionPage(child: PrayerTimeScreen()),
    isHasBottomBar: true,
  );

  static final qibla = AppRoute(
    path: '/qibla',
    pageBuilder: (context, state) => NoTransitionPage(child: QiblaScreen()),
    isHasBottomBar: true,
  );

  static final favorites = AppRoute(
    path: '/favorite',
    pageBuilder: (context, state) => NoTransitionPage(child: FavoriteScreen()),
    isHasBottomBar: true,
  );

  static final calendar = AppRoute(
    path: '/calendar',
    pageBuilder: (context, state) => NoTransitionPage(child: CalendarScreen()),
    isHasBottomBar: true,
  );

  static final explore = AppRoute(
    path: '/explore',
    pageBuilder: (context, state) => NoTransitionPage(child: ExploreScreen()),
    isHasBottomBar: true,
  );

  static final etc = AppRoute(
    path: '/etc',
    pageBuilder: (context, state) => NoTransitionPage(child: EtcScreen()),
    isHasBottomBar: true,
  );

  static final surah = AppRoute(
    path: '/surah',
    pageBuilder: (context, state) {
      int? surahId = int.tryParse(state.uri.queryParameters['id'] ?? '');
      return NoTransitionPage(child: SurahScreen(surahId: surahId,));
    },
    isHasBottomBar: true,
  );

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
