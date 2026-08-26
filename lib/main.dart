import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:inquran/components/bottom_nav_bar.dart';
import 'package:inquran/components/drawer_menu.dart';
import 'package:inquran/components/drawer_setting.dart';
import 'package:inquran/components/mic_button.dart';
import 'package:inquran/components/popup_modal.dart';
import 'package:inquran/components/transcription_text.dart';
import 'package:inquran/config/global.dart';
import 'package:inquran/data/local/dao/ayah_dao.dart';
import 'package:inquran/data/local/dao/doa_dao.dart';
import 'package:inquran/data/local/dao/juz_dao.dart';
import 'package:inquran/data/local/dao/surah_dao.dart';
import 'package:inquran/data/local/db/app_database.dart';
import 'package:inquran/repositories/ayah.dart';
import 'package:inquran/repositories/doa.dart';
import 'package:inquran/repositories/juz.dart';
import 'package:inquran/repositories/stt.dart';
import 'package:inquran/repositories/surah.dart';
import 'package:inquran/routes/go_router.dart';
import 'package:inquran/routes/route.dart';
import 'package:inquran/routes/route_model.dart';
import 'package:inquran/services/prayer.dart';
import 'package:inquran/services/stt.dart';
import 'package:inquran/services/surah_filter.dart';
import 'package:inquran/state/ui_controllers.dart';
import 'package:inquran/viewmodel/doa.dart';
import 'package:inquran/viewmodel/favorites.dart';
import 'package:inquran/viewmodel/location.dart';
import 'package:inquran/viewmodel/prayer_time.dart';
import 'package:inquran/viewmodel/stt.dart';
import 'package:inquran/viewmodel/surah.dart';
import 'package:inquran/viewmodel/surah_list.dart';
import 'package:permission_handler/permission_handler.dart' as app_settings;
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final globalConfig = GlobalConfig();
  await globalConfig.initialize();

  final db = AppDatabase();

  initializeDateFormatting('id_ID', null).then(
    (_) => runApp(
      MultiProvider(
        providers: [
          // Config
          ChangeNotifierProvider<GlobalConfig>.value(value: globalConfig),

          // DAOs
          Provider.value(value: db.surahDao),
          Provider.value(value: db.juzDao),
          Provider.value(value: db.ayahDao),
          Provider.value(value: db.doaDao),

          // Repositories
          Provider(
            create: (context) => SurahRepository(context.read<SurahDao>()),
          ),
          Provider(create: (context) => JuzRepository(context.read<JuzDao>())),
          Provider(
            create: (context) => AyahRepository(context.read<AyahDao>()),
          ),
          Provider(
            create: (context) => DoaRepository(context.read<DoaDao>()),
          ),
          Provider(
            create: (context) => SttRepository(
              context.read<SurahDao>(),
              context.read<DoaDao>(),
            ),
          ),

          // Services
          Provider(create: (_) => SttService()),
          Provider(create: (_) => SurahFilterService()),
          Provider(create: (_) => PrayerService()),

          // ViewModels
          ChangeNotifierProvider(
            create:
                (context) => SurahListViewModel(
                  context.read<SurahRepository>(),
                  context.read<SurahFilterService>(),
                  context.read<JuzRepository>(),
                ),
          ),
          ChangeNotifierProvider(
            create:
                (context) => SttViewModel(
                  context,
                  context.read<SttService>(),
                  context.read<SttRepository>(),
                ),
          ),
          ChangeNotifierProvider(
            create: (_) => LocationViewModel()..loadLocation(),
          ),
          ChangeNotifierProvider(
            create:
                (context) => SurahViewModel(context.read<AyahRepository>()),
          ),
          ChangeNotifierProvider(
            create: (context) => DoaListViewModel(context.read<DoaRepository>()),
          ),
          ChangeNotifierProvider(
            create: (context) => DoaDetailViewModel(context.read<DoaRepository>()),
          ),
          ChangeNotifierProvider(
            create: (context) => FavoritesViewModel(context.read<AyahDao>()),
          ),
          ChangeNotifierProvider(
            create:
                (context) =>
                    PrayerTimeViewModel(context.read<PrayerService>())
                      ..loadPrayerTimes(),
          ),

          // UI controllers
          ChangeNotifierProvider(create: (_) => SettingSlideDrawer()),
          ChangeNotifierProvider(create: (_) => MenuSlideDrawer()),
          ChangeNotifierProvider(create: (_) => ExitCofirmationPopUp()),
          ChangeNotifierProvider(create: (_) => PermissionErrorController()),
          ChangeNotifierProvider(create: (_) => AppSettingErrorController()),
        ],
        child: const MyApp(),
      ),
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

    return  PopScope(
      canPop: false, 
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return; 

        final canPop = GoRouter.of(context).canPop();

        if (canPop) {
          GoRouter.of(context).pop();
        } else {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            context.read<ExitCofirmationPopUp>().open();
          });
        }
      },
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SafeArea(
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
                bottomNavigationBar: Consumer<GlobalConfig>(
                  builder: (context, vm, _) {
                    if (!currentRoute.isHasBottomBar) {
                      return SizedBox.shrink();
                    } else {
                      switch (vm.isVoiceMode) {
                        case true:
                          if (currentRoute == AppRoutes.home) {
                            return SizedBox.shrink();
                          }
                          return SafeArea(
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 25),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  TranscriptionText(idleText: ''),
                                  SizedBox(height: 10),
                                  MicButton(size: 80),
                                ],
                              ),
                            ),
                          );
                        case false:
                          return BottomNavBar();
                      }
                    }
                  },
                ),
              ),
              MenuDrawer(),
              SettingDrawer(),
              PopUpModal(
                title: "Keluar Dari Aplikasi?",
                subtitle: "Apakah Kamu Yakin Untuk Keluar Dari Aplikasi?",
                controller: context.read<ExitCofirmationPopUp>(),
                buttonList: [
                  ButtonModalModel(
                    text: "Ya",
                    onButtonPressed: exitApp
                  ),
                  ButtonModalModel(
                    text: "Batal",
                    textColor: Colors.red,
                    buttonColor: Colors.white,
                    onButtonPressed: () {},
                  ),
                ],
              ),
              ErrorPopUpModal(
                title: "Gagal Membuka App Setting",
                defaultSubtitle: "Terjadi Kesalahan Tak terduga",
                controller: context.read<AppSettingErrorController>(),
                buttonList: [
                  ButtonModalModel(text: "Ok", onButtonPressed: () {}),
                ],
              ),
              ErrorPopUpModal(
                title: "Izin Diperlukan",
                defaultSubtitle: "Izin diperlukan untuk mengakses fitur ini",
                controller: context.read<PermissionErrorController>(),
                buttonList: [
                  ButtonModalModel(
                    text: "Pengaturan",
                    onButtonPressed: () {
                      try {
                        app_settings.openAppSettings();
                      } catch (e) {
                        context.read<AppSettingErrorController>().open(
                          "terdapat Kesalahan saat membuka setting : ${e.toString()}",
                        );
                      }
                    },
                  ),
                  ButtonModalModel(
                    text: "Batal",
                    textColor: Colors.red,
                    buttonColor: Colors.white,
                    onButtonPressed: () {
                      context.read<PermissionErrorController>();
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      )
    )
    ;
  }

  Future<void> exitApp() async {
  if (Platform.isAndroid) {
    SystemNavigator.pop();
  } else if (Platform.isIOS) {
  } else if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
  }
}

  Widget _buildMainContent() {
    return Positioned.fill(child: child);
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
                Colors.white.withValues(alpha: 0),
                Colors.white.withValues(alpha: 0.5),
                Colors.white.withValues(alpha: 1),
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
                Colors.purple.withValues(alpha: 0.1),
                Colors.purple.withValues(alpha: 0.15),
              ],
              stops: [0.2, 0.7, 0.9],
            ),
          ),
        ),
      ),
    );
  }
}