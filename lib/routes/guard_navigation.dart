import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mtqmnuns/routes/route.dart';
import 'package:mtqmnuns/state/auth.dart';
import 'package:mtqmnuns/viewmodel/auth.dart';
import 'package:mtqmnuns/viewmodel/toggleable.dart';
import 'package:provider/provider.dart';

extension GuardedNavigation on BuildContext {
  void authGo(String location) {
    final auth = read<AuthViewModel>();
    final route = AppRoutes.getRouteByPath(location);

    if (route.requiresAuth && auth.state is! AuthAuthenticated) {
      read<UnauthenticatedPopUp>().open();
      return;
    }

    go(location);
  }

  void authPush(String location) {
    final auth = read<AuthViewModel>();
    final route = AppRoutes.getRouteByPath(location);

    if (route.requiresAuth && auth.state is! AuthAuthenticated) {
      read<UnauthenticatedPopUp>().open();
      return;
    }

    push(location);
  }
}
