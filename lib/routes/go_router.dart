import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

typedef ShellBuilder = Widget Function(BuildContext context, GoRouterState state, Widget child);

class AppRouterConfig {
  final String initialLocation;
  final ShellBuilder mainShellBuilder;
  final List<GoRoute> appRoutes;

  AppRouterConfig({
    required this.initialLocation,
    required this.mainShellBuilder,
    required this.appRoutes,
  });

  GoRouter buildRouter() {
    return GoRouter(
      initialLocation: initialLocation,
      routes: [
        ShellRoute(
          builder: mainShellBuilder,
          routes: appRoutes,
        ),
      ],
    );
  }
}
