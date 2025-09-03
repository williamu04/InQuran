import 'package:flutter/material.dart';
import 'package:mtqmnuns/components/bottom_navbar.dart';
import 'package:mtqmnuns/components/top_bar.dart';
import 'package:go_router/go_router.dart';
import 'package:mtqmnuns/config/global.dart';
import 'package:mtqmnuns/config/go_router.dart';
import 'package:mtqmnuns/config/route.dart';
import 'package:mtqmnuns/data/local/dao/juz_dao.dart';
import 'package:mtqmnuns/data/local/dao/surah_dao.dart';
import 'package:mtqmnuns/data/local/db/app_database.dart';
import 'package:mtqmnuns/providers/location.dart';
import 'package:mtqmnuns/repositories/juz.dart';
import 'package:mtqmnuns/repositories/surah.dart';
import 'package:mtqmnuns/routes/route.dart';
import 'package:mtqmnuns/services/stt.dart';
import 'package:mtqmnuns/services/surah_filter.dart';
import 'package:mtqmnuns/viewmodel/stt.dart';
import 'package:mtqmnuns/viewmodel/surah.dart';
import 'package:mtqmnuns/viewmodel/surah_list.dart';
import 'package:provider/provider.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final globalConfig = GlobalConfig();
  await globalConfig.initialize();
  final db = AppDatabase();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<GlobalConfig>.value(value: globalConfig),

        // db dao list here
        Provider(create: (_) => db.surahDao),
        Provider(create: (_) => db.juzDao),

        // service list here
        Provider(create: (_) => SttService()),
        Provider(create: (_) => SurahFilterService()),

        // repository list here
        Provider(
          create:
              (context) => SurahRepository(
                context.read<SurahDao>(),
                context.read<JuzDao>(),
              ),
        ),

        // viewmodel list here
        ChangeNotifierProvider(
          create:
              (context) => SurahListViewModel(
                context.read<SurahRepository>(),
                context.read<SurahFilterService>(),
              ),
        ),
        ChangeNotifierProvider(
          create:
              (context) => SttViewModel(
                context.read<SttService>(),
                context.read<SurahRepository>(),
              ),
        Provider(create: (context) => SurahRepository(context.read<SurahDao>())),
        Provider(create: (context) => JuzRepository(context.read<JuzDao>())),

        // viewmodel list here
        ChangeNotifierProvider(create:(context) =>
             SurahListViewModel(
                context.read<SurahRepository>(), 
                context.read<SurahFilterService>(), 
                context.read<JuzRepository>()
              )
        ),
        ChangeNotifierProvider(
          create: (_) => LocationProvider()..loadLocation(),
          child: const MyApp(),
        ),
        ChangeNotifierProvider(create: (context) =>
             SurahDetailViewModel(context.read<SurahRepository>())
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    final config = AppRouterConfig(
      initialLocation: AppRoutes.splashScreen.path,
      mainShellBuilder: (context, state, child) {
        return MainScaffold(context: context, state: state, child: child);
      },
      appRoutes:
          AppRoutes.all
              .map(
                (route) =>
                    GoRoute(path: route.path, pageBuilder: route.pageBuilder),
              )
              .toList(),
    );

    _router = config.buildRouter();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(routerConfig: _router, theme: _buildAppTheme());
  }

  ThemeData _buildAppTheme() {
    return ThemeData(
      splashFactory: NoSplash.splashFactory,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      hoverColor: Colors.transparent,
      scaffoldBackgroundColor: Colors.white,
      colorScheme: const ColorScheme.light(),
      fontFamily: 'Plus Jakarta',
    );
  }
}

class MainScaffold extends StatelessWidget {
  final Widget child;
  final BuildContext context;
  final GoRouterState state;

  const MainScaffold({
    super.key,
    required this.child,
    required this.context,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    final String currentPath = state.uri.toString();
    final AppRoute currentRoute = AppRoutes.getRouteByPath(currentPath);

    final double topPadding =
        (!currentRoute.isHasTopBar || currentRoute.isHasPurpleBanner)
            ? 0
            : MediaQuery.of(context).padding.top + kToolbarHeight;

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        extendBody: true,
        body: Stack(
          children: [
            _buildMainContent(topPadding),
            if (currentRoute.isHasTopBar) _buildTopBar(),
            if (currentRoute.isHasBottomBar) _buildWhiteGradientOverlay(),
            _buildPurpleGradientOverlay(),
          ],
        ),
        bottomNavigationBar:
            currentRoute.isHasBottomBar ? bottomNavBar(context, state) : null,
      ),
    );
  }

  Widget _buildMainContent(double topPadding) {
    return Positioned.fill(
      child: Padding(padding: EdgeInsets.only(top: topPadding), child: child),
    );
  }

  Widget _buildTopBar() {
    return Positioned(top: 0, left: 0, right: 0, child: topBar(context, state));
  }

  Widget _buildWhiteGradientOverlay() {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: IgnorePointer(
        child: Container(
          height: 200,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.white.withOpacity(0),
                Colors.white.withOpacity(0.5),
                Colors.white.withOpacity(1),
              ],
              stops: [0.45, 0.6, 0.7],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPurpleGradientOverlay() {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: IgnorePointer(
        child: Container(
          height: 100,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                Colors.purple.withOpacity(0.1),
                Colors.purple.withOpacity(0.15),
              ],
              stops: [0.2, 0.7, 0.9],
            ),
          ),
        ),
      ),
    );
  }
}
