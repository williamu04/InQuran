import 'package:flutter/material.dart';

Widget bottomNavBar() {
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
          child : Container(
            color: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: BottomNavigationBar(
              elevation: 0,
              mouseCursor: SystemMouseCursors.basic,
              type: BottomNavigationBarType.fixed,
              currentIndex: 2,
              selectedItemColor: Color(0xFF8A3FFC), // purple
              unselectedItemColor: Colors.grey,
              selectedFontSize: 0,
              unselectedFontSize: 0,
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.menu_book), label: ''),
                BottomNavigationBarItem(icon: Icon(Icons.search), label: ''),
                BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: ''),
                BottomNavigationBarItem(icon: Icon(Icons.volunteer_activism_outlined), label: ''),
                BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: ''),
              ],
          ),
        )
      ),
    ),
  );
}

