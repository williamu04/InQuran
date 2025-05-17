import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

PreferredSizeWidget topBar(BuildContext context, GoRouterState state) {
  final  currentRoute = state.uri.toString();

  return AppBar(
    backgroundColor: Colors.transparent,
    elevation: 0,
    leading: Builder(
      builder:
          (context) => IconButton(
            icon: Icon(
            Icons.menu,
            color: currentRoute == "/book" ? Color(0xFF7C8BA0): Colors.white 
            ),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
    ),
    title: Text(
      'QuranApp',
      style: TextStyle(
        fontFamily: "Plus Jakarta",
        color: currentRoute == "/book" ? Color(0xFF672CBC) : Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 18,
      ),
    ),
    actions: [
      IconButton(
        icon: Icon(
          Icons.settings, 
          color: currentRoute == "/book" ? Color(0xFF7C8BA0): Colors.white
        ),
        onPressed: () {
          // Tpengaturan
        },
      ),
    ],
  );
}
