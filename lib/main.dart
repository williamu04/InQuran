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
          pageBuilder: (context, state) => NoTransitionPage(
            child: route.screen,
          ),
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
    // Define the list of routes that need top padding
    String currentPath = state.uri.toString();
    AppRouteConfig currentRoute = AppRoutes.getRouteByPath(currentPath);
    final double topPadding =  currentRoute.isHasPurpleBanner ? 0 : MediaQuery.of(context).padding.top + kToolbarHeight;

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        extendBody: true,
        body: Stack(
          children: [
            Positioned.fill(
              child: Padding(
                padding: EdgeInsets.only(top: topPadding),
                child: child,
              ),
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: topBar(context, state),
            ),

            Positioned(
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
                      Colors.white.withOpacity(0),   // fully transparent at the top
                      Colors.white.withOpacity(0.5), // semi-transparent
                      Colors.white.withOpacity(1),   // solid white at the bottom
                    ],
                    stops: [0.45, 0.6, 0.7], 
                  ),
                ),
              ),
            ),

            Positioned(
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
                      Colors.purple.withOpacity(0.1),  // stronger purple near bottom
                      Colors.purple.withOpacity(0.15),  // strongest purple at the very bottom
                    ],
                    stops: [0.2, 0.7, 0.9], 
                  ),
                ),
              ),
            ),


          ],
        ),
        bottomNavigationBar: bottomNavBar(context, state),
      ),
    );
  }
}

