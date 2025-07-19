
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppRoute {
  String title;
  final String path;
  final IconData icon;
  final bool isHasPurpleBanner;
  final Page<dynamic> Function(BuildContext context, GoRouterState state)
  pageBuilder;
  final Future<String> Function(GoRouterState)? dynamicTitleBuilder;
  final bool isHasTopBar;
  final bool isHasBottomBar;

  AppRoute ({
    required this.title,
    required this.path,
    required this.pageBuilder,
    required this.icon,
    required this.isHasPurpleBanner,
    required this.isHasTopBar,
    required this.isHasBottomBar,
    this.dynamicTitleBuilder,
  });
}