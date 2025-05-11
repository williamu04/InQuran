import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

Widget bottomNavBar(BuildContext context, GoRouterState state) {
  final  currentRoute = state.uri.toString();

  int currentIndex = 2; 
  if (currentRoute == '/book') {
    currentIndex = 0;
  } else if (currentRoute == '/search') {
    currentIndex = 1;
  } else if (currentRoute == '/') {
    currentIndex = 2;
  } else if (currentRoute == '/donation') {
    currentIndex = 3;
  } else if (currentRoute == '/profile') {
    currentIndex = 4;
  }

  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 24),
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: Container(
          color: Colors.white,
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: BottomNavigationBar(
            elevation: 0,
            mouseCursor: SystemMouseCursors.basic,
            type: BottomNavigationBarType.fixed,
            currentIndex: currentIndex,  
            selectedItemColor: Color(0xFF8A3FFC), // purple
            unselectedItemColor: Colors.grey,
            selectedFontSize: 0,
            unselectedFontSize: 0,
            onTap: (index) {
              switch (index) {
                case 0:
                  context.go('/book');
                  break;
                case 1:
                  context.go('/search');
                  break;
                case 2:
                  context.go('/');
                  break;
                case 3:
                  context.go('/donation');
                  break;
                case 4:
                  context.go('/profile');
                  break;
              }
            },
            items: const [
              BottomNavigationBarItem(icon: Icon(LucideIcons.bookOpen), label: ''),
              BottomNavigationBarItem(icon: Icon(LucideIcons.search), label: ''),
              BottomNavigationBarItem(icon: Icon(LucideIcons.home), label: ''),
              BottomNavigationBarItem(icon: Icon(Icons.volunteer_activism_outlined), label: ''),
              BottomNavigationBarItem(icon: Icon(LucideIcons.user), label: ''),
            ],
          ),
        ),
      ),
    ),
  );
}

