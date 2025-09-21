import 'package:flutter/material.dart';
import 'package:mtqmnuns/components/auth_popup.dart';
import 'package:mtqmnuns/components/bottom_navbar.dart';
import 'package:go_router/go_router.dart';
import 'package:mtqmnuns/components/drawer_menu.dart';
import 'package:mtqmnuns/components/drawer_setting.dart';
import 'package:mtqmnuns/config/global.dart';
import 'package:mtqmnuns/data/local/dao/ayah_dao.dart';
import 'package:mtqmnuns/data/remote/auth.dart';
import 'package:mtqmnuns/repositories/auth.dart';
import 'package:mtqmnuns/repositories/ayah.dart';
import 'package:mtqmnuns/routes/go_router.dart';
import 'package:mtqmnuns/routes/route_model.dart';
import 'package:mtqmnuns/data/local/dao/juz_dao.dart';
import 'package:mtqmnuns/data/local/dao/surah_dao.dart';
import 'package:mtqmnuns/data/local/db/app_database.dart';
import 'package:mtqmnuns/providers/location.dart';
import 'package:mtqmnuns/repositories/juz.dart';
import 'package:mtqmnuns/repositories/surah.dart';
import 'package:mtqmnuns/routes/route.dart';
import 'package:mtqmnuns/services/stt.dart';
import 'package:mtqmnuns/services/surah_filter.dart';
import 'package:mtqmnuns/viewmodel/auth.dart';
import 'package:mtqmnuns/viewmodel/drawer.dart';
import 'package:mtqmnuns/viewmodel/mushaf.dart';
import 'package:mtqmnuns/viewmodel/stt.dart';
import 'package:mtqmnuns/viewmodel/surah.dart';
import 'package:mtqmnuns/viewmodel/surah_list.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final globalConfig = GlobalConfig();
  await globalConfig.initialize();

  final db = AppDatabase();

  runApp(
    MultiProvider(
      providers: [
        // Global config
        ChangeNotifierProvider<GlobalConfig>.value(value: globalConfig),

        // DAOs
        Provider(create: (_) => db.surahDao),
        Provider(create: (_) => db.juzDao),
        Provider(create: (_) => db.ayahDao),

        // Remote
        Provider(create: (_) => TokenRemoteDataSource()),

        // Repositories
        Provider(create: (context) => SurahRepository(context.read<SurahDao>()),),
        Provider(create: (context) => JuzRepository(context.read<JuzDao>())),
        Provider(create: (context) => AyahRepository(context.read<AyahDao>())),
        Provider(create: (context) => AuthRepository(context.read<TokenRemoteDataSource>())),

        // Services
        Provider(create: (_) => SttService()),
        Provider(create: (_) => SurahFilterService()),

        // ViewModels
        ChangeNotifierProvider(
          create:
              (context) => SurahListViewModel(
                context.read<SurahRepository>(),
                context.read<SurahFilterService>(),
                context.read<JuzRepository>(), // optional if needed
              ),
        ),
        ChangeNotifierProvider(create: (context) => SttViewModel(context.read<SttService>(),context.read<SurahRepository>())),
        ChangeNotifierProvider(create: (_) => LocationProvider()..loadLocation()),
        ChangeNotifierProvider(create: (context) => SurahDetailViewModel(context.read<AyahRepository>())),
        ChangeNotifierProvider(create:(context) => MushafViewModel(context.read<AyahRepository>())),
        ChangeNotifierProvider(create: (_) => SettingSlideDrawerViewModel()),
        ChangeNotifierProvider(create: (_) => MenuSlideDrawerViewModel()),
        ChangeNotifierProvider(create: (_) => AuthPopUpViewModel()),
        ChangeNotifierProvider(create: (context) {
          final vm = AuthViewModel(context.read<AuthRepository>());
          Future.microtask(() => vm.init());
          return vm;
        }),
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

    return SafeArea(
      child: Stack(
        children: [
          Scaffold(
            resizeToAvoidBottomInset: false,
            extendBody: true,
            body: Stack(
              children: [
                _buildMainContent(),
                if (currentRoute.isHasBottomBar) _buildWhiteGradientOverlay(),
                _buildPurpleGradientOverlay(),
              ],
            ),
            bottomNavigationBar:
                currentRoute.isHasBottomBar
                    ? BottomNavBar()
                    : null,
          ),
          MenuDrawer(),
          SettingDrawer(),
          AuthRequiredPopUp(),
        ],
      ),
    );
  }

  Widget _buildMainContent() {
    return Positioned.fill(
      child:  child,
    );
  }

  Widget _buildWhiteGradientOverlay() {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: IgnorePointer(
        child: Container(
          height: 150,
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

