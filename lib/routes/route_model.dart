
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppRoute {
  final String path;
  final Page<dynamic> Function(BuildContext context, GoRouterState state)
  pageBuilder;
  final bool isHasBottomBar;
  final bool requiresAuth;

  AppRoute ({
    required this.path,
    required this.pageBuilder,
    required this.isHasBottomBar,
    this.requiresAuth = false, 
  });
}