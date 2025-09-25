import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppRoute {
  final String path;
  final Page<dynamic> Function(BuildContext context, GoRouterState state)
  pageBuilder;
  final bool isHasBottomBar;
  final String semanticsLabel;

  AppRoute({
    required this.path,
    required this.pageBuilder,
    required this.isHasBottomBar,
    required this.semanticsLabel,
  });
}
