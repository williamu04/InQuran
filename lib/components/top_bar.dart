import 'package:flutter/material.dart';

PreferredSizeWidget topBar(BuildContext context) {
  return AppBar(
    backgroundColor: Colors.deepPurpleAccent,
    elevation: 0,
    leading: Builder(
      builder:
          (context) => IconButton(
            icon: Icon(Icons.menu, color: Colors.white),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
    ),
    title: Text(
      'QuranApp',
      style: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 18,
      ),
    ),
    actions: [
      IconButton(
        icon: Icon(Icons.settings, color: Colors.white),
        onPressed: () {
          // Tpengaturan
        },
      ),
    ],
  );
}
