import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

PreferredSizeWidget topBar(BuildContext context, GoRouterState state) {
  final  currentRoute = state.uri.toString();

  return PreferredSize(
    preferredSize: Size.fromHeight(kToolbarHeight),
    child: Container(
      padding: const EdgeInsets.only(top: 12, left: 16, right: 16),
      color: Colors.transparent,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Builder(
            builder: (context) => IconButton(
              icon: Icon(
                LucideIcons.alignLeft,
                color: currentRoute == "/book" ? Color(0xFF7C8BA0) : Colors.white,
              ),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 10),
              child: Text(
                  'QuranApp',
                  style: TextStyle(
                    fontFamily: "Plus Jakarta",
                    color: currentRoute == "/book" ? Color(0xFF672CBC) : Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          IconButton(
            icon: Icon(
              LucideIcons.settings,
              color: currentRoute == "/book" ? Color(0xFF7C8BA0) : Colors.white,
            ),
            onPressed: () {
              // Settings action
            },
          ),
        ],
      ),
    ),
  );
}
