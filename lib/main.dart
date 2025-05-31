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
    final List<String> paddedUri = [AppRoutes.book.path];
    final bool shouldPadTop = paddedUri.contains(state.uri.toString());
    final double topPadding = shouldPadTop ? MediaQuery.of(context).padding.top + kToolbarHeight : 0;

    return SafeArea(
      child: Scaffold(
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
          ],
        ),
        bottomNavigationBar: bottomNavBar(context, state),
      )
    );
  }
}

