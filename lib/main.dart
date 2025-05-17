import 'package:flutter/material.dart';
import 'package:mtqmnuns/components/bottom_navbar.dart';
import 'package:mtqmnuns/components/top_bar.dart';
import 'package:mtqmnuns/screens/book.dart';
import 'package:mtqmnuns/screens/favorite.dart';
import 'package:mtqmnuns/screens/home.dart';
import 'package:go_router/go_router.dart';
import 'package:mtqmnuns/screens/profile.dart';
import 'package:mtqmnuns/screens/search.dart';

void main() => runApp(MyApp());

final GoRouter _router = GoRouter(
  initialLocation: '/',
  routes: [
    ShellRoute(
      builder: (context, state, child) {
        return MainScaffold(context: context, state: state, child: child);
      },
      routes: [
        GoRoute(
          path: '/',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: HomeScreen(),
          ),
        ),
        GoRoute(
          path:'/book',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: BookScreen(),
          ),
        ),
        GoRoute(
          path:'/search',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: SearchScreen(),
          ),
        ),
        GoRoute(
          path:'/favorite',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: FavoriteScreen(),
          ),
        ),
        GoRoute(
          path:'/profile',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: ProfileScreen(),
          ),
        ),
      ],
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
  const MainScaffold({super.key, required this.child, required this.context, required this.state});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: topBar(context),
      body: child,
      bottomNavigationBar: bottomNavBar(context, state),
    );    
  }
}
