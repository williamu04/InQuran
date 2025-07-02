
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppRoute {
  String title;
  final String path;
  final IconData icon;
  final bool isHasPurpleBanner;
  final bool isHasBar;
  final Page<dynamic> Function(BuildContext context, GoRouterState state)
  pageBuilder;
  final Future<String> Function(GoRouterState)? dynamicTitleBuilder;

  AppRoute ({
    required this.title,
    required this.path,
    required this.pageBuilder,
    required this.icon,
    required this.isHasBar,
    required this.isHasPurpleBanner,
    this.dynamicTitleBuilder,
  });
}