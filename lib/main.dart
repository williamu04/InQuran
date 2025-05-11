import 'package:flutter/material.dart';
import 'package:mtqmnuns/components/top_bar.dart';
import 'package:mtqmnuns/screens/home.dart';
import 'package:go_router/go_router.dart';
import 'package:mtqmnuns/components/side_menu.dart';

void main() => runApp(MyApp());

final GoRouter _router = GoRouter(
  initialLocation: '/home',
  routes: [
    ShellRoute(
      builder: (context, state, child) {
        return MainScaffold(child: child);
      },
      routes: [
        GoRoute(
          path: '/home',
          pageBuilder:
              (context, state) => const NoTransitionPage(child: HomeScreen()),
        ),

        // other routes
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
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.light(),
      ),
    );
  }
}

class MainScaffold extends StatelessWidget {
  final Widget child;
  const MainScaffold({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: topBar(context), drawer: SideMenu(), body: child);
  }
}
