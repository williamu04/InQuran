import 'package:flutter/material.dart';
import 'package:mtqmnuns/components/bottom_navbar.dart';
import 'package:mtqmnuns/components/top_bar.dart';
import 'package:go_router/go_router.dart';
import 'package:mtqmnuns/config/route.dart';

void main() => runApp(MyApp());

final GoRouter _router = GoRouter(
  initialLocation: AppRoutes.home.path,
  routes: [
    ShellRoute(
      builder: (context, state, child) {
        return MainScaffold(context: context, state: state, child: child);
      },
      routes: AppRoutes.all.map(
        (route) => GoRoute(
          path: route.path,
          pageBuilder: route.pageBuilder,
          ),
      ).toList()
    ),
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
      theme: ThemeData(
        splashFactory: NoSplash.splashFactory,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        hoverColor: Colors.transparent,
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.light(),
      ),
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
    final AppRouteConfig currentRoute = AppRoutes.getRouteByPath(currentPath);

    final double topPadding = currentRoute.isHasPurpleBanner
        ? 0
        : MediaQuery.of(context).padding.top + kToolbarHeight;

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        extendBody: true,
        body: Stack(
          children: [
            _buildMainContent(topPadding),
            if (currentRoute.isHasBar) _buildTopBar(),
            _buildWhiteGradientOverlay(),
            _buildPurpleGradientOverlay(),
          ],
        ),
        bottomNavigationBar: currentRoute.isHasBar
            ? bottomNavBar(context, state)
            : null,
      ),
    );
  }

  Widget _buildMainContent(double topPadding) {
    return Positioned.fill(
      child: Padding(
        padding: EdgeInsets.only(top: topPadding),
        child: child,
      ),
    );
  }

  Widget _buildTopBar() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: topBar(context, state),
    );
  }

  Widget _buildWhiteGradientOverlay() {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
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
    );
  }

  Widget _buildPurpleGradientOverlay() {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
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
    );
  }
}


