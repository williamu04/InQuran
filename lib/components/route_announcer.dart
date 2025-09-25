import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mtqmnuns/services/accessibility.dart';

class RouteAnnouncer extends StatefulWidget {
  final String label;
  final Widget child;

  const RouteAnnouncer({super.key, required this.label, required this.child});

  @override
  State<RouteAnnouncer> createState() => _RouteAnnouncerState();
}

class _RouteAnnouncerState extends State<RouteAnnouncer> {
  String _lastLabel = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _announceIfNeeded());
  }

  @override
  void didUpdateWidget(covariant RouteAnnouncer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.label != widget.label) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _announceIfNeeded());
    }
  }

  Future<void> _announceIfNeeded() async {
    if (!mounted) return;
    if (widget.label.isEmpty || widget.label == _lastLabel) return;
    _lastLabel = widget.label;
    final accessibility = context.read<AccessibilityService>();
    await accessibility.announce(context, widget.label);
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
