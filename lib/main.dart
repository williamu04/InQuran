import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mtqmnuns/components/bottom_navbar.dart';
import 'package:go_router/go_router.dart';
import 'package:mtqmnuns/components/drawer_menu.dart';
import 'package:mtqmnuns/components/drawer_setting.dart';
import 'package:mtqmnuns/components/loading_viewmodel.dart';
import 'package:mtqmnuns/components/mic_button.dart';
import 'package:mtqmnuns/components/popup_modal.dart';
import 'package:mtqmnuns/components/transcription_text.dart';
import 'package:mtqmnuns/components/transient_modal.dart';
import 'package:mtqmnuns/config/dio.dart';
import 'package:mtqmnuns/config/global.dart';
import 'package:mtqmnuns/data/local/dao/ayah_dao.dart';
import 'package:mtqmnuns/data/remote/auth.dart';
import 'package:mtqmnuns/data/remote/user.dart';
import 'package:mtqmnuns/repositories/auth.dart';
import 'package:mtqmnuns/repositories/ayah.dart';
import 'package:mtqmnuns/repositories/stt.dart';
import 'package:mtqmnuns/repositories/user.dart';
import 'package:mtqmnuns/routes/go_router.dart';
import 'package:mtqmnuns/routes/route_model.dart';
import 'package:mtqmnuns/data/local/dao/juz_dao.dart';
import 'package:mtqmnuns/data/local/dao/surah_dao.dart';
import 'package:mtqmnuns/data/local/dao/duas_dao.dart';
import 'package:mtqmnuns/data/local/db/app_database.dart';
import 'package:mtqmnuns/providers/location.dart';
import 'package:mtqmnuns/repositories/juz.dart';
import 'package:mtqmnuns/repositories/surah.dart';
import 'package:mtqmnuns/routes/route.dart';
import 'package:mtqmnuns/services/stt.dart';
import 'package:mtqmnuns/services/surah_filter.dart';
import 'package:mtqmnuns/state/user.dart';
import 'package:mtqmnuns/viewmodel/auth.dart';
import 'package:mtqmnuns/viewmodel/stt.dart';
import 'package:mtqmnuns/viewmodel/surah.dart';
import 'package:mtqmnuns/viewmodel/surah_list.dart';
import 'package:mtqmnuns/viewmodel/toggleable.dart';
import 'package:mtqmnuns/viewmodel/user.dart';
import 'package:permission_handler/permission_handler.dart' as app_settings;
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final dio = DioConfig().init();

  final globalConfig = GlobalConfig();
  await globalConfig.initialize();

  final db = AppDatabase();

  final FlutterSecureStorage storage = FlutterSecureStorage();

  final authRemote = AuthRemoteDataSource(client: dio);
  final authRepository = AuthRepository(authRemote);
  final authViewModel = await AuthViewModel.create(authRepository, storage);

  initializeDateFormatting('id_ID', null).then(
    (_) => runApp(
      MultiProvider(
        providers: [
          // Intialized
          ChangeNotifierProvider<GlobalConfig>.value(value: globalConfig),
          Provider.value(value: authRemote),
          Provider.value(value: authRepository),
          ChangeNotifierProvider<AuthViewModel>.value(value: authViewModel),

          // DAOs
          Provider.value(value: db.surahDao),
          Provider.value(value: db.juzDao),
          Provider.value(value: db.ayahDao),
          Provider.value(value: db.duasDao),

          // Remote
          Provider(create: (_) => UserRemoteDataSource(client: dio)),

          // Repositories
          Provider(
            create: (context) => SurahRepository(context.read<SurahDao>()),
          ),
          Provider(create: (context) => JuzRepository(context.read<JuzDao>())),
          Provider(
            create: (context) => AyahRepository(context.read<AyahDao>()),
          ),
          Provider(
            create:
                (context) =>
                    UserRepository(context.read<UserRemoteDataSource>()),
          ),

          Provider(
            create:
                (context) => SttRepository(
                  context.read<SurahDao>(),
                  context.read<DuasDao>(),

                  // context.read<AyahDao>(),
                ),
          ),

          // Services
          Provider(create: (_) => SttService()),
          Provider(create: (_) => SurahFilterService()),

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
          create: (_) => LocationProvider()..loadLocation(),
        ),
        ChangeNotifierProvider(
          create:
              (context) => SurahViewModel(context.read<AyahRepository>()),
        ),
        ChangeNotifierProvider(
          create:
              (context) => UserViewModel(
                context.read<UserRepository>(),
                context.read<AuthViewModel>(),
              ),
        ),
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
            create: (_) => LocationProvider()..loadLocation(),
          ),
          ChangeNotifierProvider(
            create:
                (context) =>
                    SurahViewModel(context.read<AyahRepository>()),
          ),
          ChangeNotifierProvider(
            create:
                (context) => UserViewModel(
                  context.read<UserRepository>(),
                  context.read<AuthViewModel>(),
                ),
          ),

          //toggleable ui state
          ChangeNotifierProvider(create: (_) => SettingSlideDrawer()),
          ChangeNotifierProvider(create: (_) => MenuSlideDrawer()),
          ChangeNotifierProvider(create: (_) => LogoutDialoguePopUp()),
          ChangeNotifierProvider(create: (_) => UnauthenticatedPopUp()),
          ChangeNotifierProvider(create: (_) => LogoutLoading()),
          ChangeNotifierProvider(create: (_) => OpenSettingErrorPopUp()),
          ChangeNotifierProvider(create: (_) => ExitCofirmationPopUp()),
          ChangeNotifierProvider(create: (_) => PermissionErrorController()),
          ChangeNotifierProvider(create: (_) => AppSettingErrorController()),
          ChangeNotifierProvider(create: (_) => ImageSizeTooBigErrorController()),

          ChangeNotifierProvider(create: (_) => TransientMessageService()),
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
              PopUpModal(
                title: "Kamu Belum Login",
                subtitle: "Kamu harus login untuk mengakses fitur ini",
                controller: context.read<UnauthenticatedPopUp>(),
                buttonList: [
                  ButtonModalModel(
                    text: "Login",
                    onButtonPressed: () {
                      context.push(AppRoutes.login.path);
                    },
                  ),
                ],
              ),
              PopUpModal(
                title: "Logout",
                subtitle: "Kamu yakin ingin keluar?",
                controller: context.read<LogoutDialoguePopUp>(),
                buttonList: [
                  ButtonModalModel(
                    text: "Logout",
                    onButtonPressed: () {
                      context.read<LogoutLoading>().open();
                      context.read<AuthViewModel>().logout();
                      context.read<UserViewModel>().setState(
                        UserLoadUnauthenticated(),
                      );
                      context.read<LogoutLoading>().close();
                      context.read<TransientMessageService>().showMessage(
                        context,
                        "Logout Berhasil",
                      );
                    },
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
                title: "Gambar Terlalu Besar",
                defaultSubtitle: "Terjadi Kesalahan Tak terduga",
                controller: context.read<ImageSizeTooBigErrorController>(),
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
              LoadingModal(
                text: "Logging out...",
                controller: context.read<LogoutLoading>(),
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
