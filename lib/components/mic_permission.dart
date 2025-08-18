import 'package:flutter/material.dart';

ScaffoldFeatureController<SnackBar, SnackBarClosedReason> micPermissionErrorMessage(BuildContext context) {
  return ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text('Microphone permission is required.'),
      behavior: SnackBarBehavior.floating,
    ),
  );
}