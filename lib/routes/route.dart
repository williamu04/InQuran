import 'package:go_router/go_router.dart';
import 'package:inquran/routes/route_model.dart';
import 'package:inquran/screens/doa.dart';
import 'package:inquran/screens/surah_list.dart';
import 'package:inquran/screens/favorites.dart';
import 'package:inquran/screens/intro.dart';
import 'package:inquran/screens/qibla.dart';
import 'package:inquran/screens/search.dart';
import 'package:inquran/screens/doa_list.dart';
import 'package:inquran/screens/home.dart';
import 'package:inquran/screens/surah.dart';
import 'package:inquran/screens/splash.dart';
import 'package:inquran/screens/times.dart';

class AppRoutes {
  static final intro = AppRoute(
    path: '/intro',
    pageBuilder: (context, state) => NoTransitionPage(child: IntroScreen()),
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

  static final doaList = AppRoute(
    path: '/doa/list',
    pageBuilder: (context, state) => NoTransitionPage(child: DoaListScreen()),
    isHasBottomBar: true,
  );

  static final prayer = AppRoute(
    path: '/times',
    pageBuilder:
        (context, state) => NoTransitionPage(child: PrayerTimeScreen()),
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

  static final surah = AppRoute(
    path: '/surah',
    pageBuilder: (context, state) {
      return NoTransitionPage(
        child: SurahScreen(queryParam: state.uri.queryParameters),
      );
    },
    isHasBottomBar: false,
  );

  static final doa = AppRoute(
    path: '/doa',
    pageBuilder: (context, state) {
      return NoTransitionPage(
        child: DoaScreen(queryParam: state.uri.queryParameters),
      );
    },
    isHasBottomBar: true,
  );

  static final List<AppRoute> all = [
    home,
    surahList,
    search,
    doaList,
    prayer,
    qibla,
    favorites,
    surah,
    doa,
    intro,
    splashScreen,
  ];

  static AppRoute getRouteByPath(String path) {
    final cleanPath = Uri.parse(path).path;
    return AppRoutes.all.firstWhere((route) => route.path == cleanPath);
  }
}