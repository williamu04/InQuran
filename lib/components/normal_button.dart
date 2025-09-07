import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:mtqmnuns/config/Global.dart';
import 'package:mtqmnuns/routes/route.dart';


Widget normalButton(
  BuildContext context, {
  double size = 60,
}) {
  Color color = Color(0xFF672CBC);
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      GestureDetector(
        onTap: () {
          GlobalConfig().setVoiceMode(false);
          String currentPath = GoRouterState.of(context).uri.toString();

          if (currentPath == AppRoutes.voice.path) {
            context.go(AppRoutes.home.path);
          } 
        },
        child: Container(
          height: size,
          width: size,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: Icon(
            LucideIcons.house,
            color: Colors.white,
            size: size * 0.6,
          ),
        ),
      ),
      const SizedBox(height: 6),
      SizedBox(
        width: size * 1.2,
        child: AutoSizeText(
          "Back to Normal Mode",
          maxLines: 2,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.w600,
          ),
          minFontSize: 1,
        ),
      ),
    ],
  );
}
