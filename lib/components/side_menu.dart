import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SideMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.deepPurple),
            child: Text(
              'Menu',
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Home'),
            onTap: () {
              context.go('/home'); // Navigasi ke /home
              Navigator.pop(context); // Tutup drawer
            },
          ),
          ListTile(
            leading: Icon(Icons.book),
            title: Text('Duas Collection'),
            onTap: () {
              // context.go('/duas');
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
            onTap: () {
              // context.go('/settings');
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
